-- CreateEnum
CREATE TYPE "Role" AS ENUM ('ADMIN', 'MANAGER', 'STAFF');

-- CreateEnum
CREATE TYPE "DepartmentType" AS ENUM ('TEACHING', 'NON_TEACHING');

-- CreateEnum
CREATE TYPE "SubDepartmentType" AS ENUM ('QUANTS', 'VERBALS', 'SOFTSKILLS', 'SKILLS', 'ADMINISTRATION');

-- CreateEnum
CREATE TYPE "AssignmentStatus" AS ENUM ('PENDING', 'IN_PROGRESS', 'SUBMITTED', 'VERIFIED', 'REJECTED');

-- CreateEnum
CREATE TYPE "NotificationType" AS ENUM ('ASSIGNMENT_CREATED', 'WORK_SUBMITTED', 'WORK_VERIFIED', 'WORK_REJECTED', 'RESPONSIBILITY_UPDATED', 'RESPONSIBILITY_DELETED', 'PROMOTED_TO_MANAGER', 'ACCOUNT_CREATED');

-- CreateEnum
CREATE TYPE "WorkProofType" AS ENUM ('PDF', 'IMAGE', 'TEXT');

-- CreateTable
CREATE TABLE "Employee" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "Role" NOT NULL DEFAULT 'STAFF',
    "jobTitle" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "departmentId" INTEGER,
    "subDepartmentId" INTEGER,
    "createdById" INTEGER,

    CONSTRAINT "Employee_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Department" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" "DepartmentType" NOT NULL,
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Department_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "SubDepartment" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" "SubDepartmentType" NOT NULL,
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "departmentId" INTEGER NOT NULL,
    "managerId" INTEGER,

    CONSTRAINT "SubDepartment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Responsibility" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "cycle" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "createdById" INTEGER NOT NULL,
    "subDepartmentId" INTEGER NOT NULL,
    "parentId" INTEGER,

    CONSTRAINT "Responsibility_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ResponsibilityAssignment" (
    "id" SERIAL NOT NULL,
    "status" "AssignmentStatus" NOT NULL DEFAULT 'PENDING',
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dueDate" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "responsibilityId" INTEGER NOT NULL,
    "staffId" INTEGER NOT NULL,

    CONSTRAINT "ResponsibilityAssignment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "WorkSubmission" (
    "id" SERIAL NOT NULL,
    "hoursWorked" DOUBLE PRECISION NOT NULL,
    "workProofType" "WorkProofType",
    "workProofUrl" TEXT,
    "workProofText" TEXT,
    "staffComment" TEXT,
    "managerComment" TEXT,
    "submittedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "verifiedAt" TIMESTAMP(3),
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "assignmentId" INTEGER NOT NULL,
    "staffId" INTEGER NOT NULL,
    "verifiedById" INTEGER,

    CONSTRAINT "WorkSubmission_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Comment" (
    "id" SERIAL NOT NULL,
    "content" TEXT NOT NULL,
    "isManagerComment" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "submissionId" INTEGER NOT NULL,
    "authorId" INTEGER NOT NULL,

    CONSTRAINT "Comment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Notification" (
    "id" SERIAL NOT NULL,
    "message" TEXT NOT NULL,
    "type" "NotificationType" NOT NULL,
    "read" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "EmployeeId" INTEGER NOT NULL,

    CONSTRAINT "Notification_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Employee_email_key" ON "Employee"("email");

-- CreateIndex
CREATE INDEX "Employee_email_idx" ON "Employee"("email");

-- CreateIndex
CREATE INDEX "Employee_role_idx" ON "Employee"("role");

-- CreateIndex
CREATE INDEX "Employee_departmentId_idx" ON "Employee"("departmentId");

-- CreateIndex
CREATE INDEX "Employee_subDepartmentId_idx" ON "Employee"("subDepartmentId");

-- CreateIndex
CREATE INDEX "Employee_isActive_idx" ON "Employee"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "Department_name_key" ON "Department"("name");

-- CreateIndex
CREATE INDEX "Department_type_idx" ON "Department"("type");

-- CreateIndex
CREATE INDEX "Department_isActive_idx" ON "Department"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "SubDepartment_managerId_key" ON "SubDepartment"("managerId");

-- CreateIndex
CREATE INDEX "SubDepartment_departmentId_idx" ON "SubDepartment"("departmentId");

-- CreateIndex
CREATE INDEX "SubDepartment_managerId_idx" ON "SubDepartment"("managerId");

-- CreateIndex
CREATE INDEX "SubDepartment_type_idx" ON "SubDepartment"("type");

-- CreateIndex
CREATE INDEX "SubDepartment_isActive_idx" ON "SubDepartment"("isActive");

-- CreateIndex
CREATE UNIQUE INDEX "SubDepartment_departmentId_name_key" ON "SubDepartment"("departmentId", "name");

-- CreateIndex
CREATE INDEX "Responsibility_subDepartmentId_idx" ON "Responsibility"("subDepartmentId");

-- CreateIndex
CREATE INDEX "Responsibility_createdById_idx" ON "Responsibility"("createdById");

-- CreateIndex
CREATE INDEX "Responsibility_cycle_idx" ON "Responsibility"("cycle");

-- CreateIndex
CREATE INDEX "Responsibility_parentId_idx" ON "Responsibility"("parentId");

-- CreateIndex
CREATE INDEX "Responsibility_isActive_idx" ON "Responsibility"("isActive");

-- CreateIndex
CREATE INDEX "ResponsibilityAssignment_staffId_idx" ON "ResponsibilityAssignment"("staffId");

-- CreateIndex
CREATE INDEX "ResponsibilityAssignment_status_idx" ON "ResponsibilityAssignment"("status");

-- CreateIndex
CREATE INDEX "ResponsibilityAssignment_responsibilityId_idx" ON "ResponsibilityAssignment"("responsibilityId");

-- CreateIndex
CREATE INDEX "ResponsibilityAssignment_assignedAt_idx" ON "ResponsibilityAssignment"("assignedAt");

-- CreateIndex
CREATE UNIQUE INDEX "ResponsibilityAssignment_responsibilityId_staffId_key" ON "ResponsibilityAssignment"("responsibilityId", "staffId");

-- CreateIndex
CREATE UNIQUE INDEX "WorkSubmission_assignmentId_key" ON "WorkSubmission"("assignmentId");

-- CreateIndex
CREATE INDEX "WorkSubmission_staffId_idx" ON "WorkSubmission"("staffId");

-- CreateIndex
CREATE INDEX "WorkSubmission_verifiedById_idx" ON "WorkSubmission"("verifiedById");

-- CreateIndex
CREATE INDEX "WorkSubmission_submittedAt_idx" ON "WorkSubmission"("submittedAt");

-- CreateIndex
CREATE INDEX "WorkSubmission_verifiedAt_idx" ON "WorkSubmission"("verifiedAt");

-- CreateIndex
CREATE INDEX "Comment_submissionId_idx" ON "Comment"("submissionId");

-- CreateIndex
CREATE INDEX "Comment_authorId_idx" ON "Comment"("authorId");

-- CreateIndex
CREATE INDEX "Comment_createdAt_idx" ON "Comment"("createdAt");

-- CreateIndex
CREATE INDEX "Notification_EmployeeId_read_idx" ON "Notification"("EmployeeId", "read");

-- CreateIndex
CREATE INDEX "Notification_createdAt_idx" ON "Notification"("createdAt");

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_subDepartmentId_fkey" FOREIGN KEY ("subDepartmentId") REFERENCES "SubDepartment"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Employee" ADD CONSTRAINT "Employee_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "Employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubDepartment" ADD CONSTRAINT "SubDepartment_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "Department"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "SubDepartment" ADD CONSTRAINT "SubDepartment_managerId_fkey" FOREIGN KEY ("managerId") REFERENCES "Employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Responsibility" ADD CONSTRAINT "Responsibility_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Responsibility" ADD CONSTRAINT "Responsibility_subDepartmentId_fkey" FOREIGN KEY ("subDepartmentId") REFERENCES "SubDepartment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Responsibility" ADD CONSTRAINT "Responsibility_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "Responsibility"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResponsibilityAssignment" ADD CONSTRAINT "ResponsibilityAssignment_responsibilityId_fkey" FOREIGN KEY ("responsibilityId") REFERENCES "Responsibility"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ResponsibilityAssignment" ADD CONSTRAINT "ResponsibilityAssignment_staffId_fkey" FOREIGN KEY ("staffId") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkSubmission" ADD CONSTRAINT "WorkSubmission_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "ResponsibilityAssignment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkSubmission" ADD CONSTRAINT "WorkSubmission_staffId_fkey" FOREIGN KEY ("staffId") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "WorkSubmission" ADD CONSTRAINT "WorkSubmission_verifiedById_fkey" FOREIGN KEY ("verifiedById") REFERENCES "Employee"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "WorkSubmission"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Comment" ADD CONSTRAINT "Comment_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Notification" ADD CONSTRAINT "Notification_EmployeeId_fkey" FOREIGN KEY ("EmployeeId") REFERENCES "Employee"("id") ON DELETE CASCADE ON UPDATE CASCADE;
