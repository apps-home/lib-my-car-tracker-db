import { getDriver } from './client'
import { PrismaClient } from './prisma/generated/prisma/client'

export * from './prisma/generated/prisma/client'

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }

let prismaInstance: PrismaClient | undefined

function getPrismaClient(): PrismaClient {
  if (process.env.NODE_ENV !== 'production') {
    if (!globalForPrisma.prisma) {
      globalForPrisma.prisma = new PrismaClient({ adapter: getDriver() })
    }

    return globalForPrisma.prisma
  }

  if (!prismaInstance) {
    prismaInstance = new PrismaClient({ adapter: getDriver() })
  }

  return prismaInstance
}

export const prisma = new Proxy({} as PrismaClient, {
  get(_target, prop) {
    const client = getPrismaClient()

    const value = (client as any)[prop]
    if (typeof value === 'function') {
      return value.bind(client)
    }
    return value
  }
})

const basePrisma = {
  $transaction: prisma.$transaction.bind(prisma),
  $disconnect: prisma.$disconnect.bind(prisma),
  $connect: prisma.$connect.bind(prisma),
  $executeRaw: prisma.$executeRaw.bind(prisma),
  $executeRawUnsafe: prisma.$executeRawUnsafe.bind(prisma),
  $queryRaw: prisma.$queryRaw.bind(prisma),
  $queryRawUnsafe: prisma.$queryRawUnsafe.bind(prisma)
} as const

export const prismaMyCarTracker = {
  vehicle: prisma.vehicle,
  fuelLog: prisma.fuelLog,
  vehicleExpense: prisma.vehicleExpense,
  maintenanceRecord: prisma.maintenanceRecord,
  maintenanceItem: prisma.maintenanceItem,
  maintenanceSchedule: prisma.maintenanceSchedule,
  ...basePrisma
} as const

export const prismaAuth = {
  user: prisma.user,
  account: prisma.account,
  session: prisma.session,
  verification: prisma.verification,
  ...basePrisma
} as const

export type MyCarTracker = typeof prismaMyCarTracker
export type Auth = typeof prismaAuth
