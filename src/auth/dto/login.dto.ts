import { IsEmail, IsEnum, IsNotEmpty,IsString, MinLength } from "class-validator";


export class LoginDto{
    @IsNotEmpty()
    @IsEmail()
    email: string;
    // @IsEnum(["MANAGER", "STAFF", "ADMIN"],{
    //     message: 'Valid role required'
    // })
    // role: "MANAGER" | "STAFF" | "ADMIN";
    @IsString()
    @IsNotEmpty()
    @MinLength(6)
    password: string;

}