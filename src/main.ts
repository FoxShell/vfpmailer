import 'https://kwx.kodhe.com/x/v/0.8.1/std/dist/stdlib'

import fs from '/virtual/@kawix/std/fs/mod'
import Path from 'path'
import Os from 'os'



main()
async function main(){

    try{
        let Shide = Path.join(Os.homedir(), "Kawix", "Shide.lib")
        // retro compatibilidad 
        if(!fs.existsSync(Shide)){
            
            // install Shide first
            let mod = await import("https://raw.githubusercontent.com/voxsoftware/packages/master/shide/0.0.2.kwa")
            await mod.Program.main()

        }


        console.info("Installing vfpmailer ...")

        let vfpmailerDir = Path.join(Shide, "vfpmailer")
        if(fs.existsSync(vfpmailerDir)){
            await fs.unlinkAsync(vfpmailerDir)
        }

        // copy vfpmailer
        await fs.symlinkAsync(Path.join(__dirname, "VFP"), vfpmailerDir, "junction")

        
    }catch(e){
        console.error("Failed installing shide: ",e )
    }

}
