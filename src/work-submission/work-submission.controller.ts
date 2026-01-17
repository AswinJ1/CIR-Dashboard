import { Controller, Get, Post, Body, Patch, Param, Delete, Query, UseGuards } from '@nestjs/common';
import { WorkSubmissionService } from './work-submission.service';
import { Prisma } from '@prisma/client';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';


@Controller('work-submission')
export class WorkSubmissionController {
  constructor(private readonly workSubmissionService: WorkSubmissionService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createWorkSubmissionDto: Prisma.WorkSubmissionCreateInput) {
    return this.workSubmissionService.create(createWorkSubmissionDto);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  findAll(
    @Query('staffId') staffId?: string,
    @Query('verifiedById') verifiedById?: string,
    @Query('assignmentId') assignmentId?: string,
  ) {
    return this.workSubmissionService.findAll(
      staffId ? +staffId : undefined,
      verifiedById ? +verifiedById : undefined,
      assignmentId ? +assignmentId : undefined,
    );
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  findOne(@Param('id') id: string) {
    return this.workSubmissionService.findOne(+id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  update(
    @Param('id') id: string,
    @Body() updateWorkSubmissionDto: Prisma.WorkSubmissionUpdateInput,
  ) {
    return this.workSubmissionService.update(+id, updateWorkSubmissionDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.workSubmissionService.remove(+id);
  }
}
