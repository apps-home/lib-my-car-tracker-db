import { PrismaPg } from '@prisma/adapter-pg'
import { Pool } from 'pg'

let _driver: PrismaPg | null = null

export function getDriver(): PrismaPg {
  if (!_driver) {
    const connectionString = process.env.DATABASE_URL
    const pool = new Pool({ connectionString })

    _driver = new PrismaPg(pool)
  }
  return _driver
}

export const driver = new Proxy({} as PrismaPg, {
  get(_target, prop) {
    return (getDriver() as any)[prop]
  }
})
