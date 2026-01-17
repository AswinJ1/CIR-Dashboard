import { Controller, Get, Post, Body, Patch, Param, Delete, Query ,UseGuards } from '@nestjs/common';
import { CommentsService } from './comments.service';
import { Prisma } from '@prisma/client';
import { JwtAuthGuard } from 'src/auth/jwt-auth.guard';

@Controller('comments')
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  create(@Body() createCommentDto: Prisma.CommentCreateInput) {
    return this.commentsService.create(createCommentDto);
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  findAll(
    @Query('submissionId') submissionId?: string,
    @Query('authorId') authorId?: string,
  ) {
    return this.commentsService.findAll(
      submissionId ? +submissionId : undefined,
      authorId ? +authorId : undefined,
    );
  }

  @Get(':id')
  @UseGuards(JwtAuthGuard)
  findOne(@Param('id') id: string) {
    return this.commentsService.findOne(+id);
  }

  @Patch(':id')
  @UseGuards(JwtAuthGuard)
  update(
    @Param('id') id: string,
    @Body() updateCommentDto: Prisma.CommentUpdateInput,
  ) {
    return this.commentsService.update(+id, updateCommentDto);
  }

  @Delete(':id')
  @UseGuards(JwtAuthGuard)
  remove(@Param('id') id: string) {
    return this.commentsService.remove(+id);
  }
}
