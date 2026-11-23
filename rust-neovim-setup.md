# Ambiente Rust in Neovim: modifiche e workflow

Creato il 2026-11-23. Neovim 0.12, rustc 1.100, rustaceanvim 9.2.

---

## 0. Inizia da qui (le prime 2 settimane)

Tutto il resto di questa guida è riferimento: **non serve impararlo ora.** Per partire bastano 4 tasti:

| Tasto | Quando |
|---|---|
| `<leader>ca` | c'è un errore o un warning: guarda se esiste un fix |
| `K` | non sai che tipo ha una cosa o cosa fa una funzione |
| `<leader>cd` | un errore non ti è chiaro: leggilo per intero |
| `<leader>ce` | ancora non è chiaro: la spiegazione ufficiale con un esempio |

Tutto il resto lo fanno da sole le cose automatiche: clippy al salvataggio, l'errore che si espande sulla riga del cursore, gli hint base, il formato al salvataggio.

**Non devi ricordare gli altri tasti:** premi `<leader>c` e aspetta un attimo. which-key mostra il menu "code / rust" con ogni tasto e la sua descrizione. Ogni volta che lo apri per curiosità, ne impari uno.

Aggiungi una cosa nuova **solo quando quella vecchia è diventata automatica**:
1. i 4 tasti sopra
2. bacon nel secondo terminale
3. pedantic nei progetti di learning e il rituale di fine task
4. le sessioni *deep* (`<leader>cL`, `<leader>cm`)

---

## 1. Modifiche fatte

### Sistema

| Modifica | Cosa fa |
|---|---|
| `rustup component add rust-analyzer` | Installa rust-analyzer **dalla tua toolchain**: versione allineata a rustc, aggiornata con `rustup update`. |
| Rimosso rust-analyzer di Mason (`~/.local/share/nvim/mason/packages/rust-analyzer`) | Era una seconda copia, non allineata a rustc. Mason non lo reinstalla più, perché non è più in `ensure_installed`. |
| `cargo install bacon` (3.26) | Watcher da terminale: ricompila, testa e lancia clippy a ogni salvataggio, in un pane tmux o in una seconda finestra. |
| `~/.config/bacon/prefs.toml` con `vim_keys = true` | In bacon scorri con `j`/`k` (una riga) e `g`/`G` (inizio/fine); `Space` e `PageDown`/`PageUp` per pagina. Gli altri tasti (`c`, `t`, `r`, `d`, `q`) restano invariati. |

### `~/.config/nvim/lua/plugins/rust.lua` (nuovo)

Usa **rustaceanvim** al posto di nvim-lspconfig per Rust. Avvia rust-analyzer e aggiunge i comandi `:RustLsp ...`.

- **Binario**: `~/.cargo/bin/rust-analyzer` (rustup), così nessun'altra copia nel PATH può prendere il sopravvento.
- **Clippy al salvataggio** (`check.command = "clippy"`, `allTargets`, quindi anche test ed examples). *Quali* lint girano lo decide il `Cargo.toml` di ogni progetto (vedi sotto).
- **`cargo.targetDir = true`**: rust-analyzer compila in una sua cartella (`target/rust-analyzer`), quindi non blocca il lock di cargo mentre fai `cargo run` o usi bacon. Il costo è più spazio su disco.
- **`diagnostics.styleLints`**: qualche suggerimento di stile in più, direttamente da rust-analyzer.
- **Hover con memory layout**: `K` su un tipo mostra size, align e niche, in decimale ed esadecimale.
- **Due livelli di inlay hint**:
  - *base* (sempre attivo): tipi delle variabili, nomi dei parametri, tipi nelle catene di iteratori, tipo di ritorno delle closure con blocco, lifetime elisi solo quando non banali.
  - *deep* (`<leader>cL`): rende visibile tutto ciò che il compilatore fa in silenzio:
    - lifetime elisi ovunque;
    - auto-ref e auto-deref (`&`, `*` inseriti per te);
    - reborrow (`&*x`);
    - **punti in cui avviene il `drop`**;
    - modalità di cattura delle closure;
    - `ref`/`ref mut` impliciti nei pattern;
    - discriminanti degli enum;
    - parametri lifetime generici.
- **Semantic highlighting** (si riapplica a ogni cambio di tema Omarchy):
  - variabili `mut` → <u>sottolineate</u>
  - valori **consumati (move)** → **grassetto**
  - `unsafe` → rosso, grassetto
- **Keymap** (solo nei buffer Rust, prefisso `<leader>c`):

| Tasto | Azione |
|---|---|
| `K` | hover con azioni (vai a impl, run, ...) e memory layout. Ripremi `K` per entrare nel popup e scorrerlo |
| `<leader>ca` | code action raggruppate (rust-analyzer ne ha molte) |
| `<leader>ce` | **spiega l'errore**: la voce `rustc --explain EXXXX` in una finestra |
| `<leader>cd` | **errore completo stile cargo**, con frecce, note e help |
| `<leader>cD` | salta alle posizioni collegate all'errore (es. "borrow occurs here") |
| `<leader>cm` | espandi la macro sotto il cursore: split a destra se la finestra ha almeno 160 colonne, altrimenti sotto a tutta larghezza (`<C-w>_` per ingrandirlo, `:q` per chiuderlo) |
| `<leader>cL` | attiva/disattiva gli hint **deep** |
| `<leader>ch` | attiva/disattiva tutti gli inlay hint |
| `<leader>cr` / `<leader>cR` | runnables / rilancia l'ultimo |
| `<leader>ct` | testables (lancia il test sotto il cursore) |
| `<leader>co` | apri docs.rs per il simbolo |
| `<leader>cc` / `<leader>cp` | apri `Cargo.toml` / modulo padre |

Tutti questi tasti compaiono nel menu which-key premendo `<leader>c` (gruppo "code / rust"). I float hanno il bordo arrotondato e gli split aperti da un float vanno sotto, non di lato.

**Popup (K, `<leader>ce`, `<leader>cd`, `<C-s>`)**: si aprono senza focus. **Ripremi lo stesso tasto** per entrarci, poi `j`/`k`, `<C-d>`/`<C-u>`, `/` per cercare, `q` o `<Esc>` per uscire. Fa eccezione `<leader>d`, che non è focusable.

**Azioni dell'hover di `K`**: rust-analyzer crea un "Go to …" per ogni tipo che compare nella descrizione del simbolo (parametri, ritorno, trait bound). `<CR>` su una riga apre il sorgente di quel tipo. Per la std è il codice di `rust-src`: i commenti `///` e `//!` sono **la documentazione ufficiale**, offline e della tua versione, con l'implementazione sotto. Torni indietro con `<C-t>` o `<C-o>`. Sono file della toolchain: leggili, non modificarli.

Restano attivi i keymap generici: `gd`, `gr`, `gi`, `gt`, `<leader>rn`, `<leader>d`, `<leader>xq`, format on save (rustfmt).

### `~/.config/nvim/lua/plugins/lsp.lua` (modificato)

- `rust_analyzer` tolto da `ensure_installed` e aggiunto `automatic_enable = { exclude = { "rust_analyzer" } }`. Senza questo partirebbero **due** client rust-analyzer.
- **Diagnostics ripensati** (vale per tutti i linguaggi):
  - le righe dove *non* sei mostrano una riga sola di testo, solo warning ed errori: poco rumore;
  - **la riga del cursore** mostra tutti i diagnostics per esteso, su più righe sotto il codice, compresi hint e note ("help: consider borrowing here");
  - float (`<leader>d`) con bordo arrotondato e la sorgente sempre indicata (rustc o clippy).

### `~/.config/nvim/luasnippets/toml.lua` (nuovo) e `completions.lua`

- `completions.lua` ora carica anche gli snippet Lua personali da `~/.config/nvim/luasnippets/`.
- Due snippet per `Cargo.toml` (scrivi il trigger, scegli dal menu, `<C-y>`):
  - `lintspedantic`: attiva `clippy::pedantic` ed esclude i tre lint più rumorosi (`must_use_candidate`, `missing_errors_doc`, `missing_panics_doc`).
  - `lintsbase`: lint di default più l'obbligo di motivare ogni `#[allow]`.

### `~/.config/nvim/lua/plugins/which-key.lua` (modificato)

- Il gruppo `<leader>c` si chiama "code / rust": premi `<leader>c` e aspetta, e compare il menu con tutti i tasti.

### tmux (`~/.config/tmux/`)

- `tmux.conf`: la tua config del mac adattata a Linux. `pbcopy` diventa `wl-copy`; RGB per ogni `$TERM`; percorso XDG; `focus-events` e clipboard OSC 52 per nvim; status bar con il tuo stile, ma colori `brightblack`/`cyan` del terminale, così segue il tema Omarchy.
- Plugin con TPM (`~/.config/tmux/plugins`): `tmux-sensible`, `vim-tmux-navigator`. Quest'ultimo si collega a `nvim-tmux-navigation`, già presente in nvim.
- `~/.local/bin/tmux-sessionizer`: il tuo script; cerca in `~/dev` (o `~/workspace`), escludendo `.git`, `target` e `node_modules`.
- Backup del default Omarchy: `tmux.conf.omarchy-default.bak`. **Non lanciare `omarchy-refresh-tmux`**: sovrascrive la config.

### Verifica fatta

Progetto di prova: un solo client rust-analyzer (rustup), errore E0502 con le due posizioni collegate, `clippy::needless_pass_by_value` con il suggerimento `&str`, hint 4 → 12 passando a *deep*.

---

## 2. Come usarlo senza esserne sommerso

L'idea: **velocità di default, profondità su richiesta.** L'ambiente di base è silenzioso e tu scegli quando scendere di livello. Ogni strumento "profondo" è a un tasto di distanza, ma non è mai acceso per forza.

### Layout consigliato (tmux oppure due finestre Hyprland)

Le due opzioni sono equivalenti: bacon osserva i file del progetto, quindi funziona in un pane tmux come in una seconda finestra di terminale affiancata da Hyprland.
- **Hyprland**: lancia `bacon` dalla root del progetto (dove c'è `Cargo.toml`). Ti sposti tra le finestre con il focus di Hyprland, perché `<C-h>`/`<C-l>` funzionano solo verso i pane tmux.
- **tmux** (config in `~/.config/tmux/tmux.conf`, prefix `C-b`, status bar come sul mac ma con i colori del tema Omarchy): `<C-h>`/`<C-l>` passano da nvim a bacon, e puoi riprendere la sessione dopo averla chiusa.
  - `prefix f`: sessionizer, scegli un progetto in `~/dev` con fzf e ottieni una sessione dedicata.
  - `prefix %`: split verticale nella cwd attuale, dove lanci `bacon clippy`.
  - `prefix C-l`: pulisce lo schermo della shell (`<C-l>` da solo ora serve a navigare).

```
┌──────────────────────────────┬──────────────┐
│                              │  bacon       │
│  nvim                        │  (clippy o   │
│                              │   test)      │
└──────────────────────────────┴──────────────┘
```

- `bacon clippy` mentre scrivi codice, `bacon test` quando lavori sui test (`t`/`c` dentro bacon cambiano job, `j`/`k` scorrono, `g`/`G` inizio/fine).
- L'editor ti dice **dove** è l'errore, bacon ti dà il **quadro di tutto il crate**.

### Le tre modalità

**1. Flow (sviluppo veloce, ~80% del tempo)**
- Hint *base*, scrivi e salva spesso: ogni salvataggio fa girare clippy.
- Non leggere ogni warning subito. Guarda solo i **segni rossi** (errori).
- `<leader>ca` è il primo riflesso: molti errori hanno un fix automatico.
- I warning gialli li sistemi a fine task (vedi sotto).

**2. Capire un errore (quando un errore ti blocca o non lo capisci)**

Una scala in 4 gradini. Fermati appena hai capito:
1. Metti il cursore sulla riga: l'errore si espande sotto il codice.
2. `<leader>cd`: l'output completo stile cargo, con le frecce sul codice.
3. `<leader>cD`: salta a "borrow occurs here" o "later used here" e guarda il percorso.
4. `<leader>ce`: la spiegazione ufficiale `EXXXX` con un esempio minimo.

Regola d'oro: **prima di applicare un fix automatico, prova a dire a parole perché il compilatore ha ragione.**

**3. Scavare (sessioni dedicate, 10–20 minuti, non durante il flow)**
- `<leader>cL` → hint *deep*: dove avviene il drop, dove il compilatore inserisce `&` o `*`, come cattura la closure.
- `K` su un tipo per size e layout: confronta `Option<Box<T>>` con `Box<T>` (niche!).
- `<leader>cm` sulle macro (`vec!`, `println!`, i derive).
- `:RustLsp view mir` per vedere cosa diventa davvero il codice (avanzato).
- Rispegni *deep* con `<leader>cL` quando hai finito.

### Rituale di fine task (5 minuti)

1. Leggi i warning clippy rimasti (`<leader>xq` li mette in quickfix, poi `:cnext`).
2. Per ognuno premi `<leader>cd`: in fondo all'output c'è il link alla pagina del lint ("for further information visit ..."). Leggi la sezione *Why is this bad?*.
3. Correggi, oppure zittisci con un motivo:
   ```rust
   #[expect(clippy::cast_possible_truncation, reason = "valore sempre < 256")]
   ```
4. Annota in un file (es. `~/dev/learning/rust/lints.md`) **un solo** lint nuovo che hai capito. In poche settimane diventa il tuo glossario personale.

### Lint per progetto

| Tipo di progetto | Cosa usare |
|---|---|
| `~/dev/learning/*`, rustlings, esercizi | `lintspedantic`: ogni warning è una lezione |
| progetti in cui vuoi soprattutto andare veloce (es. `kv-store` in fase di prototipo) | default di clippy o `lintsbase`; pedantic dopo, in una passata di refactoring |
| codice "serio" o da pubblicare | `lintspedantic` sin dall'inizio |

Pedantic su un progetto esistente può tirare fuori decine di warning. Attivalo e sistemali **un file alla volta**, non tutti insieme.

### Progressione suggerita

- **Settimana 1–2**: solo Flow e la scala degli errori. Rustlings in un pane tmux (`rustlings`), nvim nell'altro.
- **Settimana 3–4**: aggiungi il rituale di fine task e pedantic nei progetti di learning.
- **Dopo**: sessioni *deep* quando un concetto non ti torna (lifetime, closure, smart pointer), e `view mir` per curiosità.

---

## 3. Tornare indietro

- Hint troppo invadenti: `<leader>ch` li spegne nel buffer. Per spegnerli di default, togli `vim.lsp.inlay_hint.enable(true, ...)` in `rust.lua`.
- Diagnostics multi-riga sgraditi: in `lsp.lua` rimuovi `virtual_lines` e `current_line = false`.
- Tornare a lspconfig: elimina `lua/plugins/rust.lua` e ripristina `rust_analyzer` in `ensure_installed`, togliendo `automatic_enable`.

---

## 4. Mini-workflow: una sessione tipo

Ogni passo indica lo strumento da usare e **perché esiste** nel setup.

**Apertura**
1. **Due terminali** (Hyprland affiancati, o tmux con `prefix f` → progetto). A sinistra `nvim`, a destra `bacon clippy`.
   *Perché:* l'editor mostra gli errori del file che hai davanti, bacon quelli di tutto il crate. Ti accorgi subito se una modifica qui rompe qualcosa altrove.
2. **Progetto nuovo?** In `Cargo.toml` digita `lintspedantic` (progetto di studio) o `lintsbase` (progetto da far andare veloce).
   *Perché:* i lint stanno nel progetto, quindi editor, `cargo clippy` e bacon dicono la stessa cosa.

**Scrittura (flow)**

3. Scrivi e **salva spesso**.
   *Perché:* il salvataggio formatta (rustfmt) e lancia clippy. Il feedback arriva in 1–2 secondi senza fare nulla.
4. Guarda solo **i segni rossi**. Sulla riga del cursore l'errore si espande da solo.
   *Perché:* le altre righe restano su una riga sola, così scrivi senza rumore e leggi per esteso solo quello che stai guardando.
5. Non sai cos'è una cosa? **`K`**, poi **`K`** di nuovo per scorrere.
   *Perché:* tipo, documentazione e layout in memoria senza uscire dal codice. Le righe "Go to …" con `<CR>` ti portano alla documentazione nel sorgente della std. Torni con `<C-t>`.
6. Errore → **`<leader>ca`** prima di tutto.
   *Perché:* molti errori (import, `&`, `mut`, `clone`) hanno già un fix, e risolverli è questione di un secondo.

**Bloccato su un errore**

7. Sali la scala, fermandoti appena capisci: **riga espansa → `<leader>cd` → `<leader>cD` → `<leader>ce`**.
   *Perché:* sono quattro livelli di dettaglio crescente, dal messaggio breve al percorso del borrow alla spiegazione ufficiale con esempio. Prima di applicare il fix, dì a parole perché il compilatore ha ragione: è lì che impari.
8. Nel frattempo nel terminale di bacon scorri con **`j`/`k`** per leggere il quadro completo. Premi **`t`** per passare ai test.

**Curiosità (solo se hai tempo, non durante il flow)**

9. **`<leader>cL`** per gli hint *deep*, **`<leader>cm`** per espandere una macro. Poi rispegni.
   *Perché:* mostrano quello che il compilatore fa di nascosto (drop, `&`/`*` impliciti, catture delle closure). Utilissimi per capire, ma troppo rumorosi da tenere sempre accesi.

**Chiusura (5 minuti)**

10. **`<leader>xq`** per mettere i warning rimasti in quickfix, `:cnext` per scorrerli. Per ognuno, `<leader>cd` → link → *Why is this bad?*. Correggi, o metti `#[expect(..., reason = "...")]`.
    *Perché:* i warning li hai rimandati per restare veloce; qui li trasformi in lezioni, uno alla volta.
11. Annota **un** lint o concetto nuovo in `~/dev/learning/rust/lints.md`.
    *Perché:* uno solo è sostenibile tutti i giorni, e dopo un mese hai un glossario tuo.

> Non ricordi un tasto? `<leader>c` e aspetta: il menu which-key te li elenca tutti.
