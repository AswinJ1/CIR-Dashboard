import { Controller, Get, Post, Body, Patch, Param, Delete,Query, Res ,UseGuards } from '@nestjs/common';
import { AssignmentService } from './assignment.service';
import  {Prisma, Responsibility,Employee} from "@prisma/client";
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';

@Controller('assignment')
export class AssignmentController {
  constructor(private readonly assignmentService: AssignmentService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createAssignmentDto: Prisma.ResponsibilityAssignmentCreateInput) {
    return this.assignmentService.create(createAssignmentDto);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  findAll(
    @Query('responsibilityId') responsibilityId?: string,
    @Query('staffId') staffId?: string
  ) {
    return this.assignmentService.findAll(
      responsibilityId ? +responsibilityId : undefined,
      staffId ? +staffId : undefined
    );
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  findOne(@Param('id') id: string) {
    return this.assignmentService.findOne(+id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  update(@Param('id') id: string, @Body() updateAssignmentDto: Prisma.ResponsibilityAssignmentUpdateInput) {
    return this.assignmentService.update(+id, updateAssignmentDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.assignmentService.remove(+id);
  }
}
