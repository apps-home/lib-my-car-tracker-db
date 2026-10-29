# Banco de Dados do My Car Tracker (Prisma Schema — @lib/my-car-tracker-db)

> Submódulo Git do My Car Tracker (`packages/lib-my-car-tracker-db`) com o schema, as migrations e o client Prisma do banco (Prisma 7 + PostgreSQL).

---

## 1. Scripts e Operações do Banco

A partir da raiz do monorepo:

| Comando | Descrição |
|---|---|
| `pnpm --filter @lib/my-car-tracker-db build` | Gera o Prisma Client (`prisma generate`) e compila o TypeScript (`tsc`). |
| `pnpm --filter @lib/my-car-tracker-db migrate` | Executa e gera novas migrations em desenvolvimento (`prisma migrate dev`). |
| `pnpm --filter @lib/my-car-tracker-db migrate:deploy` | Aplica migrations pendentes em produção/CI (`prisma migrate deploy`). |
| `pnpm --filter @lib/my-car-tracker-db migrate:status` | Verifica status das migrations no banco configurado (`prisma migrate status`). |
| `pnpm --filter @lib/my-car-tracker-db push` | Sincroniza o schema diretamente no banco sem criar migration (`prisma db push`). |
| `pnpm --filter @lib/my-car-tracker-db studio` | Abre a interface web do Prisma Studio para inspeção dos dados. |

Localização do Schema: `packages/lib-my-car-tracker-db/src/prisma/schema.prisma`  
Cliente Gerado: `packages/lib-my-car-tracker-db/src/prisma/generated/prisma`

Ainda não há migrations: a primeira sai do primeiro `migrate` contra o `my_car_tracker_db`.

---

## 2. Consumo no Monorepo

- No backend (`apps/service`), o `PrismaModule` (`apps/service/src/infra/prisma/prisma.module.ts`) registra `prismaMyCarTracker` e `prismaAuth` como os providers `'prismaMyCarTracker'` e `'prismaAuth'`.
- No web, o `createAuth` do `@lib/auth/server` recebe o `prisma` completo.
- Sempre que houver alteração no `schema.prisma`, execute `pnpm --filter @lib/my-car-tracker-db build` para atualizar os tipos.
- Ao criar um model novo em `my-car-tracker`, acrescente-o ao `prismaMyCarTracker` em `src/index.ts`.

---

## 3. Banco e Credenciais

- Database próprio `my_car_tracker_db`, com role próprio `my_car_tracker`, dono só dele (cluster Neon em DEV, PostgreSQL da VM Oracle em PROD).
- O `DATABASE_URL` fica no `.env` deste pacote (CLI do Prisma) e no ambiente de cada app. Use `sslmode=verify-full` no Neon.
- `@prisma/client`, `@prisma/adapter-pg`, `pg` e `prisma` têm versões fixadas aqui (sem `catalog:`).

---

## 4. Schemas e Tabelas

Dois schemas PostgreSQL: `better-auth` (autenticação, models copiados de `@lib/auth/prisma/better-auth.prisma`) e `my-car-tracker` (domínio).

### Schema: `better-auth`

| Tabela | Descrição |
|---|---|
| `user` | Usuário da plataforma, com as relações inversas do domínio (veículos, abastecimentos, despesas, manutenções e planos). |
| `session` | Sessões ativas (`token`, `expiresAt`, `ipAddress`, `userAgent`). |
| `account` | Contas e credenciais (`providerId`, `accountId`, `issuer`, tokens OAuth, `password`). |
| `verification` | Tokens temporários de verificação e redefinição de senha. |

### Schema: `my-car-tracker`

| Tabela | Descrição |
|---|---|
| `vehicles` | Veículo do usuário (atual e anteriores), com `currentOdometerKm`, `initialOdometerKm`, placa, tanque e combustível padrão. |
| `fuel_logs` | Abastecimentos: data, odômetro, combustível, litros, preço por litro, total, `isFullTank` e consumo calculado (`distanceDrivenKm`, `consumptionKmPerLiter`, `costPerKm`). |
| `vehicle_expenses` | Despesas diversas (`ExpenseCategory`): pedágio, estacionamento, IPVA, licenciamento, seguro, lavagem, multas e acessórios. |
| `maintenance_records` | Ida à oficina (`MaintenanceType`), com mão de obra, peças, total e nota fiscal no R2. |
| `maintenance_items` | Peças e serviços de uma manutenção, com garantia (`warrantyMonths`, `warrantyUntil`) e vínculo opcional com um plano (`scheduleId`). |
| `maintenance_schedules` | Planos preventivos por tempo e/ou km (`ScheduleTriggerRule`), com última execução, próximo vencimento e `alertStatus` (`ScheduleAlertStatus`). |

### Enums

| Enum | Valores |
|---|---|
| `FuelType` | `GASOLINE_COMMON`, `GASOLINE_ADDITIVE`, `GASOLINE_PREMIUM`, `ETHANOL`, `DIESEL`, `GNV` |
| `ExpenseCategory` | `TOLL`, `PARKING`, `IPVA`, `LICENSING`, `INSURANCE`, `CAR_WASH`, `FINE`, `ACCESSORY`, `OTHER` |
| `PaymentMethod` | `TAG`, `PIX`, `CREDIT_CARD`, `DEBIT_CARD`, `CASH` |
| `MaintenanceType` | `PREVENTIVE`, `CORRECTIVE`, `INSPECTION` |
| `ScheduleTriggerRule` | `TIME_ONLY`, `ODOMETER_ONLY`, `WHICHEVER_COMES_FIRST` |
| `ScheduleAlertStatus` | `ON_TRACK`, `DUE_SOON`, `OVERDUE` |
