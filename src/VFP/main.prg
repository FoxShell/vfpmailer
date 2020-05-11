Lparameters  nodeInterop, libName


SET PROCEDURE TO SYS(16) ADDITIVE 
SET PROCEDURE TO (GETENV("userprofile") + "\Kawix\Shide.lib\nfjsoncreate")  ADDITIVE 


if pcount() > 0
	try 
		m.nodeInterop._libs.add(CREATEOBJECT("mailerStatic"), m.libName)
	catch to ex 
	endtry 
ENDIF


DEFINE CLASS mailerStatic as Custom 
	function createTransport()
		local transport
		transport= CREATEOBJECT('mailerTransport')
		return m.transport
	ENDFUNC
	 
	 
	 FUNCTION mailData()
	 RETURN CREATEOBJECT("maildata")
	 ENDFUNC 
ENDDEFINE


DEFINE CLASS mailData as Custom

	from = ''
	to = ''
	subject = ''
	text= ""
	html = ""
	attachments = null 
	
	FUNCTION init()
		this.attachments = CREATEOBJECT("collection")	
	ENDFUNC 
	FUNCTION addAttachment(path, filename, cid)
		LOCAL a 
		a= CREATEOBJECT("empty")
		if(EMPTY(m.filename)) 
			filename=justfname(m.path)
		ENDIF 
		ADDPROPERTY(m.a,"filename",m.filename)
		ADDPROPERTY(m.a,"path",m.path)
		if(!EMPTY(m.cid))
			ADDPROPERTY(m.a,"cid",m.cid)	
		ENDIF
		this.attachments.add(m.a)
	ENDFUNC 

ENDDEFINE 



DEFINE CLASS mailerTransport as custom

	host = ''
	port = 465
	secure = .f. 
	
	auth = null
	
	FUNCTION init()
		this.auth = CREATEOBJECT("empty")
		ADDPROPERTY(this.auth, "user")
		ADDPROPERTY(this.auth, "pass")
	ENDFUNC 
	
	
	FUNCTION sendmail(data)
		
		
		local num, req , id
		id= "vfp.mailer.0.0.1-4.send"
		TRY 
			num= _screen.nodeinterop._api.item[m.id]
		CATCH TO ex 
			num= "-1"
		ENDTRY 
		
		
		
		IF num == "-1"
		
			_Screen.nodeinterop.connect()
			TEXT TO m.code NOSHOW 
			var Nodemailer
			var execute = async function(){
				if(!Nodemailer){
					Nodemailer= await KModule.import("npm://nodemailer@6.4.6")
				}
				
				params = JSON.parse(params)
				var transporter = Nodemailer.createTransport(params.transport)
				if(params.mail.attachments_kl_collection){
					var index=0;
					params.mail.attachments=params.mail.attachments_kl_collection.collectionitems.map(function(a){ if(!a.cid) a.cid = index.toString(); index++; return a})
				}
				var response = await transporter.sendMail(params.mail)
				return response 
			}
			
			return execute()
			endtext
		
		
			_Screen.nodeinterop.register(m.id, m.code)
			num= _screen.nodeinterop._api.item[m.id]
		ENDIF 
		
		
		LOCAL param0, str
		param0 = CREATEOBJECT("empty")
		ADDPROPERTY(param0,"transport", this)
		ADDPROPERTY(param0,"mail", m.data)
		str = nfjsoncreate(m.param0)
		
		*?m.str
		
		RETURN _Screen.nodeinterop.execute(num, m.str, .t.)
			
		
	ENDFUNC 
	

enddefine
