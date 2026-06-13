// =============================================================================
//  Camada de dados plugável (compartilhada entre as páginas).
//    • Supabase configurado  -> modo COLABORATIVO (todos compartilham os dados)
//    • Sem config / ?local   -> modo LOCAL (localStorage, só neste navegador)
// =============================================================================
import { SUPABASE_URL, SUPABASE_ANON_KEY } from "./config.js";
import { SEED } from "./seed.js";

export const STORE_KEY = "fpInfo.v1";
export const uid = () =>
  crypto?.randomUUID?.() ?? "id" + Date.now() + Math.random().toString(36).slice(2, 8);

export class LocalStore {
  mode = "local";
  constructor() { this.locais = this.load(); }

  load() {
    try {
      const raw = localStorage.getItem(STORE_KEY);
      if (raw) return JSON.parse(raw);
    } catch (e) { /* ignora */ }
    return this.seedClone();
  }
  // copia TODOS os campos do local (inclui pais/lat/lng/preço_viagem/diaria)
  seedClone() {
    return SEED.map(({ peixes, ...l }) => ({
      id: uid(), ...l, criado_em: new Date().toISOString(),
      peixes: peixes.map((p) => ({ id: uid(), local_id: null, ...p })),
    }));
  }
  persist() { localStorage.setItem(STORE_KEY, JSON.stringify(this.locais)); }

  async init() { return this.locais; }
  getLocais() { return this.locais; }

  async addLocal({ nome, regiao, nivel, guia }) {
    this.locais.push({ id: uid(), nome, regiao: regiao || null, nivel: nivel || null, guia: guia || null, criado_em: new Date().toISOString(), peixes: [] });
    this.persist();
  }
  async delLocal(id) {
    this.locais = this.locais.filter((l) => String(l.id) !== String(id));
    this.persist();
  }
  async addPeixe(localId, fish) {
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    if (!loc) return;
    loc.peixes.push({ id: uid(), local_id: localId, criado_em: new Date().toISOString(), ...fish });
    this.persist();
  }
  async updatePeixe(localId, fishId, fish) {
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    const i = loc?.peixes.findIndex((p) => String(p.id) === String(fishId)) ?? -1;
    if (i < 0) return;
    loc.peixes[i] = { ...loc.peixes[i], ...fish };
    this.persist();
  }
  async delPeixe(localId, fishId) {
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    if (loc) loc.peixes = loc.peixes.filter((p) => String(p.id) !== String(fishId));
    this.persist();
  }
  async reset() { this.locais = this.seedClone(); this.persist(); }
}

export class SupabaseStore {
  mode = "cloud";
  constructor(client) { this.client = client; this.locais = []; }

  static async create() {
    const { createClient } = await import("https://esm.sh/@supabase/supabase-js@2");
    return new SupabaseStore(createClient(SUPABASE_URL, SUPABASE_ANON_KEY));
  }

  async init() {
    const { data: locais, error: e1 } = await this.client.from("locais_pesca").select("*").order("id");
    if (e1) throw new Error("Erro ao ler 'locais_pesca': " + e1.message + " (rodou o schema.sql?)");
    const { data: peixes, error: e2 } = await this.client.from("peixes").select("*").order("id");
    if (e2) throw new Error("Erro ao ler 'peixes': " + e2.message + " (rodou o schema.sql?)");
    const byLocal = {};
    for (const p of peixes ?? []) (byLocal[p.local_id] ??= []).push(p);
    this.locais = (locais ?? []).map((l) => ({ ...l, peixes: byLocal[l.id] ?? [] }));
    return this.locais;
  }
  getLocais() { return this.locais; }

  async addLocal({ nome, regiao, nivel, guia }) {
    const { data, error } = await this.client
      .from("locais_pesca").insert({ nome, regiao: regiao || null, nivel: nivel || null, guia: guia || null }).select().single();
    if (error) throw new Error(error.message);
    this.locais.push({ ...data, peixes: [] });
  }
  async delLocal(id) {
    const { error } = await this.client.from("locais_pesca").delete().eq("id", id);
    if (error) throw new Error(error.message);
    this.locais = this.locais.filter((l) => String(l.id) !== String(id));
  }
  async addPeixe(localId, fish) {
    const { data, error } = await this.client
      .from("peixes").insert({ ...fish, local_id: localId }).select().single();
    if (error) throw new Error(error.message);
    this.locais.find((l) => String(l.id) === String(localId))?.peixes.push(data);
  }
  async updatePeixe(localId, fishId, fish) {
    const { data, error } = await this.client
      .from("peixes").update(fish).eq("id", fishId).select().single();
    if (error) throw new Error(error.message);
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    const i = loc?.peixes.findIndex((p) => String(p.id) === String(fishId)) ?? -1;
    if (i >= 0) loc.peixes[i] = data;
  }
  async delPeixe(localId, fishId) {
    const { error } = await this.client.from("peixes").delete().eq("id", fishId);
    if (error) throw new Error(error.message);
    const loc = this.locais.find((l) => String(l.id) === String(localId));
    if (loc) loc.peixes = loc.peixes.filter((p) => String(p.id) !== String(fishId));
  }
  async reset() { throw new Error("local-only"); }
}

// Cria e inicializa o store conforme config + ?local. Lança em caso de erro.
export async function createStore() {
  const search = globalThis.window?.location?.search ?? "";
  const forceLocal = new URLSearchParams(search).has("local");
  const wantsCloud = !forceLocal && !!(SUPABASE_URL && SUPABASE_ANON_KEY);
  const store = wantsCloud ? await SupabaseStore.create() : new LocalStore();
  await store.init();
  return store;
}
