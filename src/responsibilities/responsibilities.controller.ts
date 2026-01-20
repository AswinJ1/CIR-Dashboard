import { Controller, Get, Post, Body, Patch, Param, Delete, Query, UseGuards, Request } from '@nestjs/common';
import { ResponsibilitiesService } from './responsibilities.service';
import { Prisma, SubDepartmentType } from '@prisma/client';
import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { RolesGuard } from '../auth/guards/roles.guard';


@Controller('responsibilities')
@UseGuards(JwtAuthGuard, RolesGuard)
export class ResponsibilitiesController {
  constructor(private readonly responsibilitiesService: ResponsibilitiesService) {}

  @Post()
  @Roles('ADMIN', 'MANAGER', 'STAFF')
  create(
    @Body() createResponsibilityDto: Prisma.ResponsibilityCreateInput & {
      startDate?: string;
      endDate?: string;
      isStaffCreated?: boolean;
    },
    @Request() req,
  ) {
    const { startDate, endDate, isStaffCreated, ...dto } = createResponsibilityDto;
    return this.responsibilitiesService.createWithDateValidation(
      dto,
      req.user.id,
      req.user.role,
      req.user.subDepartmentId,
      startDate ? new Date(startDate) : undefined,
      endDate ? new Date(endDate) : undefined,
      isStaffCreated,
    );
  }

  @Get()
  @Roles('ADMIN', 'MANAGER', 'STAFF')
  findAll(
    @Query('includeExpired') includeExpired?: string,
    @Request() req?,
  ) {
    return this.responsibilitiesService.findAllScoped(
      req.user.id,
      req.user.role,
      req.user.subDepartmentId,
      includeExpired === 'true',
    );
  }

  /**
   * Get responsibilities active for today
   */
  @Get('active/today')
  @Roles('ADMIN', 'MANAGER', 'STAFF')
  getActiveToday(@Request() req) {
    return this.responsibilitiesService.getActiveForDate(
      req.user.id,
      req.user.role,
      req.user.subDepartmentId,
      new Date(),
    );
  }

  /**
   * Get responsibilities active for a specific date
   */
  @Get('active/:date')
  @Roles('ADMIN', 'MANAGER', 'STAFF')
  getActiveForDate(
    @Param('date') dateStr: string,
    @Request() req,
  ) {
    const date = new Date(dateStr);
    if (isNaN(date.getTime())) {
      throw new Error('Invalid date format. Use YYYY-MM-DD');
    }
    return this.responsibilitiesService.getActiveForDate(
      req.user.id,
      req.user.role,
      req.user.subDepartmentId,
      date,
    );
  }

  @Get(':id')
  @Roles('ADMIN', 'MANAGER', 'STAFF')
  findOne(@Param('id') id: string) {
    return this.responsibilitiesService.findOne(+id);
  }

  @Get(':id/employees')
  @Roles('ADMIN', 'MANAGER', 'STAFF')
  getAssignedEmployees(@Param('id') id: string) {
    return this.responsibilitiesService.getAssignedEmployees(+id);
  }

  @Patch(':id')
  @Roles('ADMIN', 'MANAGER')
  update(@Param('id') id: string, @Body() updateResponsibilityDto: Prisma.ResponsibilityUpdateInput) {
    return this.responsibilitiesService.update(+id, updateResponsibilityDto);
  }

  @Delete(':id')
  @Roles('ADMIN', 'MANAGER')  // ← Add MANAGER here
  remove(@Param('id') id: string) {
    return this.responsibilitiesService.remove(+id);
  }
}