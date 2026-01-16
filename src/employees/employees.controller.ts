import { Controller, Get, Post, Body, Patch, Param, Delete,Query,Ip, UseGuards, Request} from '@nestjs/common';
import { EmployeesService } from './employees.service';
import { Prisma } from '@prisma/client';
import { Throttle,SkipThrottle } from '@nestjs/throttler';
import { LoggerService } from '../logger/logger.service';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';
import { ChangePasswordDto } from './dto/change-password.dto';


@Controller('employees')
export class EmployeesController {
  constructor(private readonly employeesService: EmployeesService) {}
  private readonly logger = new LoggerService(EmployeesController.name);

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createEmployeeDto: Prisma.EmployeeCreateInput) {
    return this.employeesService.create(createEmployeeDto);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  findAll(@Ip() ip: string, @Query('role') role: 'ADMIN' | 'MANAGER' | 'STAFF' ) {
    this.logger.log(`Request for All Employees\t${ip}`,
    EmployeesController.name);
    return this.employeesService.findAll(role);
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  findOne(@Param('id') id: string) {
    return this.employeesService.findOne(+id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  update(@Param('id') id: string, @Body() updateEmployeeDto: Prisma.EmployeeUpdateInput) {
    return this.employeesService.update(+id, updateEmployeeDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.employeesService.remove(+id);
  }

  // @Post('change-password')
  // @UseGuards(JwtAuthGuard)
  // async changePassword(
  //   @Request() req,
  //   @Body() changePasswordDto: ChangePasswordDto
  // ) {
  //   return this.employeesService.changePassword(
  //     req.employee.id,
  //     changePasswordDto.currentPassword,
  //     changePasswordDto.newPassword
  //   );
  // }
}
