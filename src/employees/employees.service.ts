import { Injectable, NotFoundException, UnauthorizedException } from '@nestjs/common';
import { Prisma } from '@prisma/client';
import { DatabaseService } from 'src/database/database.service';
import * as bcrypt from 'bcrypt';
export const roundsOfHashing = 10;

@Injectable()
export class EmployeesService {
  constructor(private readonly databaseService: DatabaseService) {}
  async create(createEmployeeDto: Prisma.EmployeeCreateInput) {
    const hashedPassword = await bcrypt.hash(createEmployeeDto.password, roundsOfHashing);
    createEmployeeDto.password = hashedPassword;
    return this.databaseService.employee.create(
      {
        data: createEmployeeDto,
      }
    )
  }

  async findAll( role: 'ADMIN' | 'MANAGER' | 'STAFF' ) {
    if (role) return  this.databaseService.employee.findMany
    ({
      where:{
        role,
      }
    })
    return  this.databaseService.employee.findMany()
  }

  async findOne(id: number) {
    return this.databaseService.employee.findUnique({
      where:{
        id,
      }
    })
  }

  async update(id: number, updateEmployeeDto: Prisma.EmployeeUpdateInput) {
    if (updateEmployeeDto.password) {
      const passwordValue = typeof updateEmployeeDto.password === 'string' 
        ? updateEmployeeDto.password 
        : updateEmployeeDto.password.set;
      if (passwordValue) {
        updateEmployeeDto.password = await bcrypt.hash(passwordValue, roundsOfHashing);
      }
    }
    return this.databaseService.employee.update({
      where:{
        id,
      },
      data: updateEmployeeDto,
    })
  }

  async remove(id: number) {
      return this.databaseService.employee.delete({
      where:{
        id,
      }
    })
  }

  // async changePassword(userId: number, currentPassword: string, newPassword: string) {
  //   // 1. Find the user
  //   const user = await this.databaseService.employee.findUnique({
  //     where: { id: userId }
  //   });

  //   if (!user) {
  //     throw new NotFoundException('User not found');
  //   }

  //   // 2. Verify current password
  //   const isPasswordValid = await bcrypt.compare(currentPassword, user.password);
    
  //   if (!isPasswordValid) {
  //     throw new UnauthorizedException('Current password is incorrect');
  //   }

  //   // 3. Hash and save new password
  //   const hashedPassword = await bcrypt.hash(newPassword, roundsOfHashing);
    
  //   return this.databaseService.employee.update({
  //     where: { id: userId },
  //     data: { password: hashedPassword }
  //   });
  // }
}
