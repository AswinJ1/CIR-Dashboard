-- AlterTable
ALTER TABLE "Responsibility" ADD COLUMN     "endDate" TIMESTAMP(3),
ADD COLUMN     "isStaffCreated" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "startDate" TIMESTAMP(3);

-- AlterTable
ALTER TABLE "WorkSubmission" ADD COLUMN     "workDate" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- CreateIndex
CREATE INDEX "Responsibility_startDate_idx" ON "Responsibility"("startDate");

-- CreateIndex
CREATE INDEX "Responsibility_endDate_idx" ON "Responsibility"("endDate");

-- CreateIndex
CREATE INDEX "WorkSubmission_staffId_workDate_idx" ON "WorkSubmission"("staffId", "workDate");

-- CreateIndex
CREATE INDEX "WorkSubmission_workDate_idx" ON "WorkSubmission"("workDate");
