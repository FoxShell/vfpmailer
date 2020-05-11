* testmail
DO (GETENV("userprofile") + "\Kawix\Shide\interop")


* First download an image using vfp.axios, to attach to mail
LOCAL req, response , ImageFile, axios 
imageFile = GETENV("userprofile") + "\zorro.png"
if(!FILE(m.imageFile))

    * a fox picture 
    axios = _screen.nodeinterop.loadLibrary("axios")
    req = axios.create()
    req.params.responsetype = 'arraybuffer'
    req.url = "https://vignette.wikia.nocookie.net/reinoanimalia/images/8/88/Zorro_rojo_4.png/revision/latest?path-prefix=es"
    response = req.getResponse()

    * save in documents folder
    STRTOFILE(response.data, imageFile)

endif 



LOCAL mailer,transporter, data

mailer = _screen.nodeinterop.loadLibrary("vfpmailer/main")
transporter=mailer.createTransport()

data= mailer.mailData()

m.data.from= "yourusername@gmail.com"
m.data.to= "developer@kodhe.com"
m.data.subject = 'Mail from VFP'
m.data.text = 'Hola mundo!'


* get this PRG
prg = JUSTPATH(SYS(16)) + "\"+ JUSTstem(SYS(16)) + ".prg"
m.data.addAttachment(m.prg, "mailsend_example.prg")


* embed an image
* please change this to your environment
m.data.addAttachment(m.imageFile, "imagen.png")
* for embed images use cid:$index_of_attachment_starting_at_0
m.data.html= 'Hola <b style="color:red">mundo</b><br/><br/> <img src="cid:1"/>'


transporter.host="smtp.gmail.com"
transporter.secure=.t.
transporter.port=465

transporter.auth.user = "yourusername@gmail.com"
transporter.auth.pass = "yourpassword"

transporter.sendMail(m.data)