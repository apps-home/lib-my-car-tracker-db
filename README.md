# @lib/my-car-tracker-db

Schema, migrations e client Prisma do banco do My Car Tracker (`my_car_tracker_db`).

## Como começar

1. Instale as dependências na raiz do monorepo: `pnpm install`.
2. Copie o `.env.example` para `.env` e preencha o `DATABASE_URL` do `my_car_tracker_db`.
3. Gere o client e compile: `pnpm build`.

## Scripts

| Script | O que faz |
|---|---|
| `pnpm build` | `prisma generate` + `tsc` para `dist/` |
| `pnpm migrate` | Cria e aplica uma migration em desenvolvimento (`prisma migrate dev`) |
| `pnpm migrate:deploy` | Aplica as migrations pendentes (produção/CI) |
| `pnpm migrate:status` | Mostra o estado das migrations no banco configurado |
| `pnpm push` | Sincroniza o schema sem criar migration (`prisma db push`) |
| `pnpm studio` | Abre o Prisma Studio |

## Uso no monorepo

```json
{
  "dependencies": {
    "@lib/my-car-tracker-db": "workspace:*"
  }
}
```

O pacote exporta `prisma` (um client por processo), os recortes `prismaMyCarTracker` (models de `my-car-tracker`) e `prismaAuth` (models de `better-auth`) e os tipos `MyCarTracker` e `Auth`.
