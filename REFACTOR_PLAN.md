# Refactor Plan — alljobs API

Roteiro de melhorias seguindo boas práticas Rails + padrões 37signals.
Executar em fases, do mais crítico ao incremental.

---

## Fase 1 — Bugs críticos

### 1.1 JWT payload inconsistente ❌

**Problema:** `Authenticate` gera `{ user_id: }` / `{ headhunter_id: }`, mas `Token` lê
`requester_type` / `requester_id`. A autenticação não funciona corretamente.

**Arquivos:**
- `app/models/concerns/authenticate.rb` — métodos `user_payload` / `headhunter_payload`
- `app/controllers/concerns/token.rb` — `authenticate_with_token`

**Fix:** Unificar payload para `{ requester_id:, requester_type: }` em `Authenticate`.

```ruby
# authenticate.rb — payloads corrigidos
def user_payload
  @payload = { requester_id: @account.id, requester_type: "User" }
end

def headhunter_payload
  @payload = { requester_id: @account.id, requester_type: "Headhunter" }
end
```

- [x] Corrigir `user_payload` e `headhunter_payload` em `Authenticate`
- [x] Verificar que `Token#authenticate_with_token` lê `requester_type` / `requester_id` ✓

---

### 1.2 `has_many :headhunters` duplicado em `Profile` ❌

**Problema:** Duas associações com o mesmo nome — a segunda silenciosamente sobrescreve a primeira.

**Arquivo:** `app/models/profile.rb`

```ruby
# BUGADO — segunda linha sobrescreve a primeira
has_many :headhunters, through: :comments
has_many :headhunters, through: :applies  # ← sobrescreve
```

**Fix:** Usar nomes distintos.

```ruby
has_many :commenting_headhunters, through: :comments, source: :headhunter
has_many :starring_headhunters,   through: :applies,  source: :headhunter
```

- [x] Renomear as associações em `profile.rb`
- [x] Atualizar qualquer referência a `.headhunters` no código/specs

---

### 1.3 `Job#check_duplicated_code` com bugs ❌

**Problemas:**
- Faz duas queries para o mesmo registro
- É `public` sendo chamado de `before_validation`
- Adiciona erro mas não impede o código duplicado de ser atribuído

**Arquivo:** `app/models/job.rb`

**Fix:** Usar validação com `uniqueness` + simplificar `generate_code`.

```ruby
validates :code, uniqueness: true

def generate_code
  self.code = loop do
    candidate = SecureRandom.alphanumeric(8).capitalize
    break candidate unless Job.exists?(code: candidate)
  end
end
```

- [x] Remover `check_duplicated_code`
- [x] Adicionar `validates :code, uniqueness: true`
- [x] Simplificar `generate_code`

---

## Fase 2 — Segurança

### 2.1 JWT sem algoritmo explícito ❌

**Problema:** `JWT.decode` sem especificar algoritmo permite algorithm injection (`alg: none`).

**Arquivo:** `lib/json_web_token.rb`

```ruby
# ANTES — vulnerável
JWT.encode(payload, secret)
JWT.decode(token, secret)

# DEPOIS — seguro
JWT.encode(payload, secret, "HS256")
JWT.decode(token, secret, true, algorithms: ["HS256"])
```

- [x] Adicionar `"HS256"` no encode
- [x] Adicionar `algorithms: ["HS256"]` no decode

---

### 2.2 `constantize` em dado de token (risco de execução arbitrária) ❌

**Problema:** `@requester_type.constantize` usa string do payload JWT para instanciar classes.
Se o token for forjado ou o secret vazar, isso permite chamar qualquer constante.

**Arquivo:** `app/controllers/concerns/token.rb`

```ruby
# ANTES — perigoso
def requester_exists?
  @requester_type.constantize.find(@requester_id)
end

# DEPOIS — whitelist explícita
ALLOWED_REQUESTER_TYPES = %w[User Headhunter].freeze

def requester_exists?
  return false unless ALLOWED_REQUESTER_TYPES.include?(@requester_type)
  @requester_type.constantize.find(@requester_id)
end
```

- [x] Adicionar `ALLOWED_REQUESTER_TYPES` whitelist em `Token`
- [x] Guardar com `return false` antes do `constantize`

---

## Fase 3 — Rails idiomático (padrões 37signals)

### 3.1 Criar `Current` model ✨

**Motivação:** Contexto de request acessível em models/jobs sem passar parâmetros.

**Arquivo novo:** `app/models/current.rb`

```ruby
class Current < ActiveSupport::CurrentAttributes
  attribute :requester_id, :requester_type

  def user?
    requester_type == "User"
  end

  def headhunter?
    requester_type == "Headhunter"
  end
end
```

Setar em `Token#authenticate_with_token` após validação:

```ruby
Current.requester_id   = @requester_id
Current.requester_type = @requester_type
```

- [x] Criar `app/models/current.rb`
- [x] Setar `Current` no `Token` concern após autenticação
- [x] Substituir `@requester_id` / `@requester_type` nas guards por `Current.*`

---

### 3.2 Mover `set_*` do `ApiController` para os controllers corretos

**Problema:** `ApiController` tem `set_apply`, `set_job`, `set_profile` etc. — acoplamento desnecessário.
O padrão 37signals é: cada controller declara seu próprio `before_action`.

**Arquivo:** `app/controllers/api/v1/api_controller.rb`

- [x] Remover `set_apply`, `set_job_id`, `set_job`, `set_profile`, `set_star`, `set_comment` de `ApiController`
- [x] Adicionar `before_action :set_job, only: [...]` em cada controller individualmente
- [x] Mover os métodos `set_*` para `private` de cada controller

---

### 3.3 Trocar `if save` por `save!` + `rescue_from`

**Motivação (37signals):** "Let it crash" — `save!` levanta exceção em falha de validação.
`rescue_from` centraliza o tratamento de erros no `ApiController`.

**Arquivo:** `app/controllers/api/v1/api_controller.rb`

```ruby
rescue_from ActiveRecord::RecordInvalid do |e|
  render status: :unprocessable_entity, json: { errors: e.record.errors.full_messages }
end
```

Nos controllers:

```ruby
# ANTES
if @job.save
  render status: :created, json: @job
else
  render status: :precondition_failed, json: { errors: @job.errors.full_messages }
end

# DEPOIS
@job.save!
render status: :created, json: @job, location: api_v1_job_path(@job)
```

- [x] Adicionar `rescue_from ActiveRecord::RecordInvalid` em `ApiController`
- [x] Converter `JobsController` para `save!` / `update!` / `destroy!`
- [x] Converter `AppliesController`
- [x] Converter `ProfilesController`
- [x] Converter `StarsController`
- [x] Converter `CommentsController`

---

### 3.4 Corrigir HTTP status codes

**Problema:** `precondition_failed` (412) é usado para erros de validação. O correto é `unprocessable_entity` (422).

| Situação | Status correto |
|---|---|
| Validação falhou | 422 `unprocessable_entity` |
| Não encontrado | 404 `not_found` |
| Não autorizado | 401 `unauthorized` |
| Proibido | 403 `forbidden` |
| Criado | 201 `created` |
| Sem conteúdo | 204 `no_content` |

- [x] Substituir todos os `precondition_failed` por `unprocessable_entity` (resolvido ao fazer 3.3)

---

### 3.5 Remover `rescue StandardError` dos `show` actions

**Problema:** Silencia erros reais e torna debugging impossível.
O `rescue_from ActiveRecord::RecordNotFound` no `ApiController` já cobre o caso legítimo.

```ruby
# ANTES — esconde erros
def show
  render status: :ok, json: @job
rescue StandardError
  render status: :not_found, json: @job
end

# DEPOIS — limpo
def show
  render status: :ok, json: @job
end
```

- [x] Remover `rescue StandardError` de `JobsController#show`
- [x] Remover `rescue StandardError` de `AppliesController#show`
- [x] Remover `rescue StandardError` de `ProfilesController#show`
- [x] Remover `rescue StandardError` de `JobsController#stars`

---

### 3.6 Remover `include Token` redundante nos controllers

**Problema:** `Token` já está incluído em `ApiController`. Os subcontrollers incluem de novo.

- [x] Remover `include Token` de `JobsController`
- [x] Remover `include Token` de `AppliesController`
- [x] Remover `include Token` de `ProfilesController`

---

## Fase 4 — Qualidade de modelos e API

### 4.1 Corrigir N+1 em `Job#stars`

**Arquivo:** `app/models/job.rb`

```ruby
# ANTES — N+1
def stars(headhunter_id)
  applies.map { |apply| apply.stars.where(headhunter_id:) }.flatten
end

# DEPOIS
def stars(headhunter_id)
  Star.joins(:apply).where(applies: { job_id: id }, headhunter_id:)
end
```

- [x] Corrigir `Job#stars`

---

### 4.2 Corrigir `Apply#user_email` (query desnecessária)

**Arquivo:** `app/models/apply.rb`

```ruby
# ANTES — query extra
def user_email
  @user = User.find(user_id)
  @user.email.to_s
end

# DEPOIS — usa associação
def user_email
  user.email
end
```

- [x] Corrigir `Apply#user_email`

---

### 4.3 Escopar `Profile.all` e `Apply.all`

**Problema:** Qualquer usuário autenticado vê todos os perfis e candidaturas.

**`AppliesController#index`:** Filtrar pelo job ou pelo usuário autenticado.
**`ProfilesController#index`:** Apenas headhunters (já tem `before_action :not_headhunter`),
mas ainda expõe todos os perfis sem filtro.

- [ ] Definir escopo correto para `Apply.all` em `AppliesController#index`
- [ ] Avaliar se `Profile.all` precisa de filtro ou paginação

---

### 4.4 Adicionar paginação

Nenhum endpoint de index tem paginação. Com volume de dados cresce, isso se torna um problema.
Sugestão: gem `pagy` (leve, sem dependências).

- [ ] Adicionar `pagy` ao `Gemfile`
- [ ] Paginar `JobsController#index`
- [ ] Paginar `AppliesController#index`
- [ ] Paginar `ProfilesController#index`

---

### 4.5 Corrigir typo `educacional_background`

Coluna com typo na migração original.

- [ ] Decidir: corrigir via migration `rename_column` ou manter e usar alias
- [ ] Atualizar controllers, specs e serializers

---

## Fase 5 — Features faltando para um job board básico

> Análise do que existe vs. o mínimo esperado de um serviço de empregos funcional.

---

### 5.1 Uploads — avatar e currículo no `Profile` ❌

Não há nenhum upload no sistema. Para um perfil de candidato isso é essencial.

**O que falta:**
- Avatar/foto do candidato (`has_one_attached :avatar`)
- Currículo em PDF (`has_one_attached :resume`)
- Logo da empresa no `Company` (`has_one_attached :logo`)

**Gem:** Rails já tem Active Storage — não precisa de gem extra.

```ruby
# app/models/profile.rb
has_one_attached :avatar
has_one_attached :resume  # PDF
```

- [ ] Rodar `rails active_storage:install` e migrar
- [ ] Adicionar `has_one_attached :avatar` e `:resume` em `Profile`
- [ ] Adicionar `has_one_attached :logo` em `Company`
- [ ] Expor URLs nos endpoints (`rails_blob_url`)
- [ ] Adicionar validação de tipo/tamanho dos arquivos

---

### 5.2 Emails — cobertura muito limitada ❌

Atualmente só existe `ProfileMailer#successful_action` (criação/atualização de perfil).
Faltam os emails mais importantes do fluxo:

| Evento | Destinatário | Status |
|---|---|---|
| Registro de usuário (boas-vindas) | User | ❌ |
| Registro de headhunter (boas-vindas) | Headhunter | ❌ |
| Nova candidatura submetida | User (confirmação) | ❌ |
| Nova candidatura recebida | Headhunter (alerta) | ❌ |
| Candidatura favoritada (starred) | User | ❌ |
| Vaga expirando em breve | Headhunter/Company | ❌ |
| Perfil criado/atualizado | User | ✅ (existe) |

**Gem:** `letter_opener` para preview em dev.

- [ ] Criar `UserMailer` com `welcome` e `apply_confirmed`
- [ ] Criar `HeadhunterMailer` com `welcome` e `new_apply_received`
- [ ] Enviar email ao criar `Apply` (via `after_create_commit` ou job)
- [ ] Enviar email ao criar `Star` (notificar o user que foi favoritado)
- [ ] Adicionar `letter_opener` ao grupo `:development`

---

### 5.3 Status da candidatura — sem ciclo de vida ❌

`Apply` não tem status. O único sinal de feedback é a `Star` (headhunter favorita).
Para um candidato, não há como saber em que estado está a candidatura.

**O que falta:**

```ruby
# Sugestão de estados
enum :status, %i[submitted reviewing shortlisted rejected hired]
```

Ou seguindo o padrão 37signals (state as records):
- `Apply::Shortlist` — substitui `Star` com semântica mais clara
- `Apply::Rejection` — headhunter rejeita formalmente

**Decisão de design:** manter `Star` simples (favorito interno do headhunter) e adicionar `status` no `Apply` para comunicação com o candidato.

- [ ] Decidir abordagem (enum vs. state records)
- [ ] Adicionar migration para `status` em `applies`
- [ ] Expor `status` no endpoint de `Apply`
- [ ] Notificar user por email ao mudar status

---

### 5.4 Filtros e busca de vagas — muito básico ❌

`Job.search` filtra só por título. Candidatos precisam filtrar por:

| Filtro | Status |
|---|---|
| Título | ✅ |
| Nível (junior/senior etc.) | ❌ |
| País / Cidade | ❌ |
| Faixa salarial (min/max) | ❌ |
| Remoto/Presencial/Híbrido | ❌ (campo não existe) |
| Tipo de contrato | ❌ (campo não existe) |
| Status (apenas publicadas) | ❌ (retorna tudo) |

Além disso, `Job` tem apenas um `salary` decimal — sem min/max.

- [ ] Adicionar campo `work_mode` ao `Job` (`remote`, `hybrid`, `on_site`)
- [ ] Adicionar campo `contract_type` (`full_time`, `part_time`, `contract`, `freelance`)
- [ ] Considerar separar `salary` em `salary_min` / `salary_max`
- [ ] Filtrar `index` por padrão apenas vagas `published`
- [ ] Adicionar filtros por `level`, `country_id`, `work_mode` no `JobsController#index`

---

### 5.5 `Company` sem controller ❌

`Company` existe como model mas não há `CompaniesController`.
Não é possível criar, listar ou gerenciar empresas via API.
Atualmente o `company_id` precisa já existir no banco — não há como criá-lo.

- [ ] Criar `Api::V1::CompaniesController` com `index`, `show`, `create`, `update`
- [ ] Definir quem pode criar/editar empresas (headhunter? qualquer autenticado?)
- [ ] Adicionar `resources :companies` nas rotas

---

### 5.6 `Country` sem controller ❌

Mesmo problema — `Country` não tem endpoint de listagem.
O client não tem como saber os IDs válidos para `country_id`.

- [ ] Criar `Api::V1::CountriesController` com `index` (read-only, público)
- [ ] Adicionar `resources :countries, only: [:index]` nas rotas

---

### 5.7 Multitenancy — não aplicável nesta arquitetura

O modelo atual é um **job board público** (agregador):
- Headhunters postam vagas de diferentes empresas
- Candidatos (Users) se candidatam
- Não há "empresa com seus próprios usuários isolados"

Multitenancy (Apartment/acts_as_tenant) faz sentido quando cada empresa/cliente
tem seus próprios dados isolados (ex: SaaS B2B). Aqui não é o caso.

**O que pode fazer sentido no futuro:** associar um `Headhunter` a uma `Company`
para controlar quem pode criar vagas em nome de qual empresa.

- [ ] Avaliar se headhunters devem pertencer a uma `Company`
- [ ] Se sim: `Headhunter belongs_to :company` + autorização ao criar `Job`

---

### 5.8 Autenticação — sem confirmação de email e sem logout ❌

- Devise tem `:confirmable` disponível mas não ativado — qualquer email falso pode criar conta
- JWT não tem refresh token nem endpoint de logout (tokens vivem 24h fixas)
- Não há rate limiting nos endpoints de auth (brute force possível)

- [ ] Habilitar `:confirmable` no Devise para `User` e `Headhunter`
- [ ] Adicionar endpoint `DELETE /api/v1/auth` para logout (invalidar token via lista negra ou JTI)
- [ ] Avaliar rate limiting (gem `rack-attack`)

---

### 5.9 Skills/Tags nas vagas e perfis ❌

`Job` tem `skills` como texto livre. `Profile` tem `experience` como texto livre.
Não há como buscar "vagas que precisam de Ruby" ou "perfis com React".

- [ ] Criar model `Skill` ou usar tags (gem `acts-as-taggable-on`)
- [ ] Associar `Job has_many :skills` e `Profile has_many :skills`
- [ ] Filtrar vagas por skill no index

---

## Fase 6 — Modernização da infraestrutura ✅ (parcialmente concluída)

### 6.1 Ruby atualizado para 3.4.4 ✅
- [x] `.tool-versions` atualizado para `ruby 3.4.4`
- [x] `Gemfile` atualizado de `3.2.6` para `3.4.4`

### 6.2 Rails atualizado de 7.1 para 8.1 ✅
- [x] `rails '~> 8.0'` no Gemfile
- [x] `config.load_defaults 8.0` em `application.rb`
- [x] Removido `require 'rails/all'` — substituído por require seletivo (API-only)
- [x] Removido `config.cache_classes` (deprecated) → `config.enable_reloading`
- [x] Removido `web_console` (não faz sentido em API-only)
- [x] Corrigido `config.assets` removido de initializer
- [x] Adicionado `rubocop-rails` ao Gemfile e `.rubocop.yml`
- [x] `rspec-rails` atualizado para `~> 7.0`
- [x] `byebug` substituído por `debug` (padrão Rails 8)

### 6.3 Docker compose limpo ✅
- [x] Novo `docker-compose.yml` — apenas postgres 16, sem Redis (solid_queue usa DB)
- [x] Container com nome `alljobs_db`, healthcheck, volume persistente
- [x] Porta 5433 (evita conflito com outros projetos locais)
- [x] `database.yml` atualizado — porta via `ENV['DATABASE_PORT']` (default 5433 dev/test, 5432 prod)

### 6.4 Kamal para deploy ✅ (gem instalada)
- [x] `gem 'kamal'` e `gem 'thruster'` adicionados ao Gemfile
- [ ] Criar `config/deploy.yml` com configuração Kamal
- [ ] Atualizar `Dockerfile` para padrão Rails 8 (multi-stage, non-root user)
- [ ] Configurar secrets no Kamal (DATABASE_URL, SECRET_KEY_BASE, etc.)

---

## Fase 7 — Limpeza de arquivos legados

> Remover arquivos que sobraram de versões antigas (app com views, Webpacker, Spring)
> e que não fazem sentido num projeto API-only Rails 8.

### 7.1 Assets e pipeline CSS/JS

O projeto já foi um app com views e Tailwind CSS compilado via Webpacker.
Nada disso existe mais — mas os arquivos ficaram.

- [ ] Remover `app/assets/` inteiro (`builds/`, `config/manifest.js`, `images/.keep`, `stylesheets/`)
- [ ] Remover `yarn.lock` (sem JavaScript no projeto)
- [ ] Remover `vendor/.keep` (diretório vazio sem uso)

### 7.2 Spring e Webpacker

Ambas as ferramentas foram removidas do `Gemfile` mas os configs ficaram.

- [ ] Remover `bin/spring`
- [ ] Remover `bin/webpack` + `bin/webpack-dev-server` + `bin/yarn`
- [ ] Remover `config/spring.rb`
- [ ] Remover `config/webpacker.yml`
- [ ] Remover `config/webpack/` (4 arquivos: `development.js`, `environment.js`, `production.js`, `test.js`)
- [ ] Remover `.browserslistrc`

### 7.3 Initializers vazios / inaplicáveis

Arquivos gerados pelo scaffold do Rails que estão todos comentados ou são irrelevantes para API.

- [ ] Remover `config/initializers/cookies_serializer.rb` (API-only não usa cookies)
- [ ] Remover `config/initializers/inflections.rb` (todo comentado, sem customizações)
- [ ] Remover `config/initializers/mime_types.rb` (todo comentado, sem customizações)
- [ ] Remover `config/initializers/permissions_policy.rb` (todo comentado, sem uso)

### 7.4 Traduções de UI removida

Arquivos de i18n para navbar e botões CRUD de uma versão com views — sem uso na API.

- [ ] Remover `config/locales/pt-BR.navbar.yml`
- [ ] Remover `config/locales/pt-BR.crud-words.yml`

### 7.5 `.gitignore`

O `.gitignore` tem entradas duplicadas e não cobre arquivos gerados localmente.

- [ ] Remover linhas duplicadas (`/public/packs`, `/node_modules`, `yarn-debug.log*`, etc.)
- [ ] Adicionar `tmp/local_secret.txt` ao `.gitignore`
- [ ] Adicionar `app/assets/builds/` ao `.gitignore` (se assets voltarem no futuro)

---

## Fase 8 — Testes: migrar de RSpec + FactoryBot para Minitest + Fixtures

> Motivação: Minitest é o padrão Rails. Fixtures são mais rápidas (dados já no banco) e
> evitam o overhead do FactoryBot em cada teste. 37signals usa Minitest + Fixtures.

### 7.1 Setup inicial

- [ ] Adicionar `gem 'minitest-spec-rails'` ao Gemfile (opcional — para syntax spec-like)
- [ ] Remover `rspec-rails`, `factory_bot_rails`, `faker` do Gemfile
- [ ] Rodar `rails generate minitest:install` para gerar helpers base
- [ ] Configurar `test/test_helper.rb` com Shoulda-matchers para Minitest (ou usar asserts nativos)

### 7.2 Criar fixtures

Fixtures ficam em `test/fixtures/`. Uma por model, com dados realistas mas fixos.

```yaml
# test/fixtures/users.yml
john:
  email: john@example.com
  encrypted_password: <%= BCrypt::Password.create('password123') %>

jane:
  email: jane@example.com
  encrypted_password: <%= BCrypt::Password.create('password123') %>
```

- [ ] Criar `users.yml`
- [ ] Criar `headhunters.yml`
- [ ] Criar `companies.yml`
- [ ] Criar `countries.yml`
- [ ] Criar `jobs.yml`
- [ ] Criar `profiles.yml`
- [ ] Criar `applies.yml`
- [ ] Criar `stars.yml`
- [ ] Criar `comments.yml`

### 7.3 Migrar specs de model → Minitest

Para cada `spec/models/*.rb` criar `test/models/*_test.rb`:

```ruby
# test/models/job_test.rb
require 'test_helper'

class JobTest < ActiveSupport::TestCase
  test 'requires title' do
    job = jobs(:one)
    job.title = nil
    assert_not job.valid?
  end

  test 'generates code on create' do
    assert_equal 8, jobs(:one).code.length
  end
end
```

- [ ] Migrar `job_spec.rb`
- [ ] Migrar `profile_spec.rb`
- [ ] Migrar `apply_spec.rb`
- [ ] Migrar `comment_spec.rb`
- [ ] Migrar `star_spec.rb`
- [ ] Migrar `user_spec.rb`
- [ ] Migrar `headhunter_spec.rb`

### 7.4 Migrar specs de request → Minitest

```ruby
# test/controllers/api/v1/jobs_controller_test.rb
require 'test_helper'

class Api::V1::JobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @headhunter = headhunters(:one)
    @token = JsonWebToken.encode(requester_id: @headhunter.id, requester_type: 'Headhunter')
    @headers = { 'Authorization' => @token }
  end

  test 'GET index returns jobs' do
    get api_v1_jobs_path, headers: @headers, as: :json
    assert_response :ok
    assert_equal 2, response.parsed_body.length
  end
end
```

- [ ] Migrar `jobs_api_spec.rb`
- [ ] Migrar `profiles_api_spec.rb`
- [ ] Migrar `applies_api_spec.rb`
- [ ] Migrar `tokens_api_spec.rb`
- [ ] Migrar `stars_api_spec.rb`
- [ ] Migrar `comments_api_spec.rb`
- [ ] Migrar `jobs_stars_api_spec.rb`
- [ ] Migrar specs de routing

### 7.5 Limpeza

- [ ] Remover pasta `spec/`
- [ ] Remover `spec/spec_helper.rb` e `spec/rails_helper.rb`
- [ ] Remover gems RSpec, FactoryBot, Faker do Gemfile

---

## Fase 9 — Frontend com Tailwind (avaliação)

> Pergunta central: este projeto precisa de FE? E se sim, qual abordagem?

### 8.1 Contexto atual

O projeto é 100% API JSON. Não há views, assets, nem layout HTML.
Para ser um projeto completo, faz sentido ter uma interface, mas a pergunta é **qual tipo**:

| Abordagem | Prós | Contras |
|---|---|---|
| **Rails + Hotwire + Tailwind** | Padrão 37signals, zero JS framework, rápido | Precisa adicionar views/layouts de volta |
| **React/Vue SPA separado** | Flexível, pode reusar a API existente | Dois repositórios, complexidade |
| **Rails API + componentes simples** | Simples, tudo no mesmo repo | Menos interatividade |

### 8.2 Recomendação

Para um projeto de estudo que quer seguir o padrão 37signals:
**Rails + Hotwire (Turbo + Stimulus) + Tailwind CSS** — tudo no mesmo app.

Isso implica:
- Remover `config.api_only = true`
- Adicionar `gem 'turbo-rails'` e `gem 'stimulus-rails'`
- Adicionar `gem 'tailwindcss-rails'`
- Criar views para: lista de vagas, detalhe da vaga, perfil do candidato, dashboard do headhunter
- Manter a API JSON existente (vai continuar funcionando)

### 8.3 Páginas mínimas para um job board completo

- [ ] Decidir abordagem (Hotwire vs SPA)
- [ ] `GET /jobs` — listagem pública de vagas com busca/filtro
- [ ] `GET /jobs/:code` — detalhe da vaga
- [ ] `GET /profiles/:id` — perfil público do candidato (para headhunters)
- [ ] `GET /dashboard` — dashboard do headhunter (candidaturas, stars)
- [ ] Formulário de candidatura integrado ao fluxo da API

---

## Referências

- Documentação 37signals: `/home/jonjo/Code/jr/server-and-portal/backend/docs/37signals/`
  - `controllers.md` — thin controllers, concerns, resource scoping
  - `models.md` — rich models, state as records, let it crash
  - `security-checklist.md` — checklist de segurança
