import { ConsoleLogger, Injectable } from '@nestjs/common';
import * as fs from 'fs';
import * as path from 'path';
import {promises as fsPromises} from 'fs';
import { time } from 'console';
@Injectable()
export class LoggerService  extends ConsoleLogger{
    async logToFile(entry){
        const formatterEntry =  `${Intl.DateTimeFormat('en-US',{
            dateStyle:'short',
            timeStyle:'short',
            timeZone:'Asia/Kolkata',
        }).format(new Date())} - ${entry}\n`;
        try{
            if (!fs.existsSync(path.join(__dirname,'..','..','logs'))){
                await fsPromises.mkdir(path.join(__dirname,'..','..','logs'));
            }
            await fsPromises.appendFile(path.join(__dirname,'..','..','logs','app.log'),formatterEntry);
        } catch (e){
            if (e instanceof Error) console.error(e.message);

        }
        };
      
   
    log(message: any, context?: string ){
        const entry = `${context}\t${message}`;
        this.logToFile(entry);
        super.log(message,context);
    }
    error(message: any, stackOrContext?: string | undefined)
    {
        const entry = `${stackOrContext} ${message}`;
        this.logToFile(entry);
        super.error(message, stackOrContext);
    }

}