-- CreateEnum
CREATE TYPE "my-car-tracker"."MaintenanceTaskPriority" AS ENUM ('NEXT_VISIT', 'FUTURE');

-- AlterTable
ALTER TABLE "my-car-tracker"."fuel_logs"
ADD COLUMN "reimbursedAmount" DECIMAL(12,2) NOT NULL DEFAULT 0,
ADD COLUMN "sharedWith" TEXT;

-- CreateTable
CREATE TABLE "my-car-tracker"."maintenance_tasks" (
    "id" TEXT NOT NULL,
    "vehicleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "priority" "my-car-tracker"."MaintenanceTaskPriority" NOT NULL DEFAULT 'NEXT_VISIT',
    "targetYear" INTEGER,
    "notes" TEXT,
    "isCompleted" BOOLEAN NOT NULL DEFAULT false,
    "completedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "maintenance_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "maintenance_tasks_vehicleId_isCompleted_priority_idx" ON "my-car-tracker"."maintenance_tasks"("vehicleId", "isCompleted", "priority");

-- CreateIndex
CREATE INDEX "maintenance_tasks_userId_idx" ON "my-car-tracker"."maintenance_tasks"("userId");

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_tasks" ADD CONSTRAINT "maintenance_tasks_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "my-car-tracker"."vehicles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_tasks" ADD CONSTRAINT "maintenance_tasks_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

