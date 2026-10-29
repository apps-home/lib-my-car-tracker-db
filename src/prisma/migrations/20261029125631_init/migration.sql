-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "better-auth";

-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "my-car-tracker";

-- CreateEnum
CREATE TYPE "my-car-tracker"."FuelType" AS ENUM ('GASOLINE_COMMON', 'GASOLINE_ADDITIVE', 'GASOLINE_PREMIUM', 'ETHANOL', 'DIESEL', 'GNV');

-- CreateEnum
CREATE TYPE "my-car-tracker"."ExpenseCategory" AS ENUM ('TOLL', 'PARKING', 'IPVA', 'LICENSING', 'INSURANCE', 'CAR_WASH', 'FINE', 'ACCESSORY', 'OTHER');

-- CreateEnum
CREATE TYPE "my-car-tracker"."PaymentMethod" AS ENUM ('TAG', 'PIX', 'CREDIT_CARD', 'DEBIT_CARD', 'CASH');

-- CreateEnum
CREATE TYPE "my-car-tracker"."MaintenanceType" AS ENUM ('PREVENTIVE', 'CORRECTIVE', 'INSPECTION');

-- CreateEnum
CREATE TYPE "my-car-tracker"."ScheduleTriggerRule" AS ENUM ('TIME_ONLY', 'ODOMETER_ONLY', 'WHICHEVER_COMES_FIRST');

-- CreateEnum
CREATE TYPE "my-car-tracker"."ScheduleAlertStatus" AS ENUM ('ON_TRACK', 'DUE_SOON', 'OVERDUE');

-- CreateTable
CREATE TABLE "better-auth"."user" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "emailVerified" BOOLEAN NOT NULL DEFAULT false,
    "image" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "better-auth"."session" (
    "id" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "token" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "userId" TEXT NOT NULL,

    CONSTRAINT "session_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "better-auth"."account" (
    "id" TEXT NOT NULL,
    "accountId" TEXT NOT NULL,
    "providerId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "accessToken" TEXT,
    "refreshToken" TEXT,
    "idToken" TEXT,
    "accessTokenExpiresAt" TIMESTAMP(3),
    "refreshTokenExpiresAt" TIMESTAMP(3),
    "scope" TEXT,
    "password" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "issuer" TEXT NOT NULL,

    CONSTRAINT "account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "better-auth"."verification" (
    "id" TEXT NOT NULL,
    "identifier" TEXT NOT NULL,
    "value" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "verification_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "my-car-tracker"."vehicles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "brand" TEXT NOT NULL,
    "model" TEXT NOT NULL,
    "modelYear" INTEGER NOT NULL,
    "manufactureYear" INTEGER,
    "licensePlate" TEXT,
    "color" TEXT,
    "currentOdometerKm" INTEGER NOT NULL,
    "initialOdometerKm" INTEGER NOT NULL,
    "fuelTankCapacityLiters" INTEGER,
    "defaultFuelType" "my-car-tracker"."FuelType" NOT NULL DEFAULT 'GASOLINE_COMMON',
    "photoUrl" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vehicles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "my-car-tracker"."fuel_logs" (
    "id" TEXT NOT NULL,
    "vehicleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "odometerKm" INTEGER NOT NULL,
    "fuelType" "my-car-tracker"."FuelType" NOT NULL,
    "liters" DECIMAL(10,3) NOT NULL,
    "pricePerLiter" DECIMAL(10,3) NOT NULL,
    "totalCost" DECIMAL(12,2) NOT NULL,
    "isFullTank" BOOLEAN NOT NULL DEFAULT true,
    "gasStationName" TEXT,
    "paymentMethod" "my-car-tracker"."PaymentMethod",
    "distanceDrivenKm" INTEGER,
    "consumptionKmPerLiter" DECIMAL(10,2),
    "costPerKm" DECIMAL(10,4),
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "fuel_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "my-car-tracker"."vehicle_expenses" (
    "id" TEXT NOT NULL,
    "vehicleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "category" "my-car-tracker"."ExpenseCategory" NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "amount" DECIMAL(12,2) NOT NULL,
    "description" TEXT NOT NULL,
    "locationOrRoute" TEXT,
    "odometerKm" INTEGER,
    "paymentMethod" "my-car-tracker"."PaymentMethod",
    "receiptUrl" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "vehicle_expenses_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "my-car-tracker"."maintenance_records" (
    "id" TEXT NOT NULL,
    "vehicleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "type" "my-car-tracker"."MaintenanceType" NOT NULL DEFAULT 'PREVENTIVE',
    "title" TEXT NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "odometerKm" INTEGER NOT NULL,
    "workshopName" TEXT,
    "laborCost" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "partsCost" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "totalAmount" DECIMAL(12,2) NOT NULL,
    "invoiceUrl" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "maintenance_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "my-car-tracker"."maintenance_items" (
    "id" TEXT NOT NULL,
    "maintenanceRecordId" TEXT NOT NULL,
    "scheduleId" TEXT,
    "name" TEXT NOT NULL,
    "brand" TEXT,
    "partNumber" TEXT,
    "quantity" DECIMAL(10,2) NOT NULL DEFAULT 1,
    "unitPrice" DECIMAL(12,2) NOT NULL,
    "totalPrice" DECIMAL(12,2) NOT NULL,
    "warrantyMonths" INTEGER,
    "warrantyUntil" TIMESTAMP(3),

    CONSTRAINT "maintenance_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "my-car-tracker"."maintenance_schedules" (
    "id" TEXT NOT NULL,
    "vehicleId" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "triggerRule" "my-car-tracker"."ScheduleTriggerRule" NOT NULL DEFAULT 'WHICHEVER_COMES_FIRST',
    "intervalMonths" INTEGER,
    "intervalKm" INTEGER,
    "lastExecutedAt" TIMESTAMP(3),
    "lastExecutedOdometerKm" INTEGER,
    "nextDueDate" TIMESTAMP(3),
    "nextDueOdometerKm" INTEGER,
    "alertDaysBefore" INTEGER NOT NULL DEFAULT 30,
    "alertKmBefore" INTEGER NOT NULL DEFAULT 500,
    "alertStatus" "my-car-tracker"."ScheduleAlertStatus" NOT NULL DEFAULT 'ON_TRACK',
    "lastNotifiedAt" TIMESTAMP(3),
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "maintenance_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "user_email_idx" ON "better-auth"."user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "better-auth"."user"("email");

-- CreateIndex
CREATE INDEX "session_userId_idx" ON "better-auth"."session"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "session_token_key" ON "better-auth"."session"("token");

-- CreateIndex
CREATE INDEX "account_userId_idx" ON "better-auth"."account"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "account_issuer_accountId_key" ON "better-auth"."account"("issuer", "accountId");

-- CreateIndex
CREATE INDEX "verification_identifier_idx" ON "better-auth"."verification"("identifier");

-- CreateIndex
CREATE INDEX "vehicles_userId_isActive_idx" ON "my-car-tracker"."vehicles"("userId", "isActive");

-- CreateIndex
CREATE INDEX "fuel_logs_vehicleId_date_idx" ON "my-car-tracker"."fuel_logs"("vehicleId", "date" DESC);

-- CreateIndex
CREATE INDEX "fuel_logs_vehicleId_odometerKm_idx" ON "my-car-tracker"."fuel_logs"("vehicleId", "odometerKm" DESC);

-- CreateIndex
CREATE INDEX "fuel_logs_userId_idx" ON "my-car-tracker"."fuel_logs"("userId");

-- CreateIndex
CREATE INDEX "vehicle_expenses_vehicleId_category_date_idx" ON "my-car-tracker"."vehicle_expenses"("vehicleId", "category", "date" DESC);

-- CreateIndex
CREATE INDEX "vehicle_expenses_vehicleId_date_idx" ON "my-car-tracker"."vehicle_expenses"("vehicleId", "date" DESC);

-- CreateIndex
CREATE INDEX "vehicle_expenses_userId_idx" ON "my-car-tracker"."vehicle_expenses"("userId");

-- CreateIndex
CREATE INDEX "maintenance_records_vehicleId_date_idx" ON "my-car-tracker"."maintenance_records"("vehicleId", "date" DESC);

-- CreateIndex
CREATE INDEX "maintenance_records_vehicleId_odometerKm_idx" ON "my-car-tracker"."maintenance_records"("vehicleId", "odometerKm" DESC);

-- CreateIndex
CREATE INDEX "maintenance_records_userId_idx" ON "my-car-tracker"."maintenance_records"("userId");

-- CreateIndex
CREATE INDEX "maintenance_items_maintenanceRecordId_idx" ON "my-car-tracker"."maintenance_items"("maintenanceRecordId");

-- CreateIndex
CREATE INDEX "maintenance_items_scheduleId_idx" ON "my-car-tracker"."maintenance_items"("scheduleId");

-- CreateIndex
CREATE INDEX "maintenance_schedules_vehicleId_isActive_idx" ON "my-car-tracker"."maintenance_schedules"("vehicleId", "isActive");

-- CreateIndex
CREATE INDEX "maintenance_schedules_userId_alertStatus_idx" ON "my-car-tracker"."maintenance_schedules"("userId", "alertStatus");

-- AddForeignKey
ALTER TABLE "better-auth"."session" ADD CONSTRAINT "session_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "better-auth"."account" ADD CONSTRAINT "account_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."vehicles" ADD CONSTRAINT "vehicles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."fuel_logs" ADD CONSTRAINT "fuel_logs_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "my-car-tracker"."vehicles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."fuel_logs" ADD CONSTRAINT "fuel_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."vehicle_expenses" ADD CONSTRAINT "vehicle_expenses_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "my-car-tracker"."vehicles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."vehicle_expenses" ADD CONSTRAINT "vehicle_expenses_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_records" ADD CONSTRAINT "maintenance_records_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "my-car-tracker"."vehicles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_records" ADD CONSTRAINT "maintenance_records_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_items" ADD CONSTRAINT "maintenance_items_maintenanceRecordId_fkey" FOREIGN KEY ("maintenanceRecordId") REFERENCES "my-car-tracker"."maintenance_records"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_items" ADD CONSTRAINT "maintenance_items_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES "my-car-tracker"."maintenance_schedules"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_schedules" ADD CONSTRAINT "maintenance_schedules_vehicleId_fkey" FOREIGN KEY ("vehicleId") REFERENCES "my-car-tracker"."vehicles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "my-car-tracker"."maintenance_schedules" ADD CONSTRAINT "maintenance_schedules_userId_fkey" FOREIGN KEY ("userId") REFERENCES "better-auth"."user"("id") ON DELETE CASCADE ON UPDATE CASCADE;
