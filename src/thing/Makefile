debugging:=false
EXE:=false
AIR:=false
NET:=false
IS_26:=true
PROJECT:=大事记
ifeq ($(OS),Windows_NT)
IS_26:=false
HOME:=d:
FLEX_HOME:= $(HOME)/sdk/15
endif
ifeq ($(debugging),true)
PUBLISH:=false
else
PUBLISH:=true
endif
SERVER:=thingsMain
CLIENT:=thingsMain
APP_DIR:=../../../
CLIENT_AIR:=$(APP_DIR)$(PROJECT).exe
CLIENT_IPA:=$(APP_DIR)$(CLIENT).ipa
CLIENT_APP_XML:=$(SWF_DIR)$(CLIENT)-app.xml
SERVER_APP_XML:=$(SWF_DIR)$(SERVER)-app.xml
SERVER_APP_XML1:=$(SWF_DIR)$(SERVER)-26app1.xml
SERVER_APP_XML2:=$(SWF_DIR)$(SERVER)-26app2.xml
SERVER_APP_XML3:=$(SWF_DIR)$(SERVER)-26app3.xml
SERVER_APP_XML4:=$(SWF_DIR)$(SERVER)-26app4.xml

ASSET :=$(PROJECT) time.txt
SERVER_AIR:=$(APP_DIR)$(PROJECT).exe
AS_SERVER:=$(SERVER).as
AS_SERVER1:=$(SERVER)1.as
AS_SERVER2:=$(SERVER)2.as
AS_SERVER3:=$(SERVER)3.as
AS_SERVER4:=$(SERVER)4.as
SERVER_PATH:=.#.as文件所在目录
CLIENT_PATH:=.#.as文件所在目录
SERVER_AS:= $(foreach x,${SERVER_PATH}, $(wildcard $(addprefix ${x}/*,.as))) $(foreach x,.., $(wildcard $(addprefix ${x}/*,.as)))
CLIENT_AS:= $(foreach x,${SERVER_PATH}, $(wildcard $(addprefix ${x}/*,.as))) $(foreach x,.., $(wildcard $(addprefix ${x}/*,.as)))
AS_CLIENT:=$(CLIENT).as
AS_PATH :=..

ifeq ($(IS_26),true)
FLEX_HOME:= $(HOME)/flex_sdk_4.5
SERVER_APP_XML:=$(SWF_DIR)$(SERVER)-26app.xml
CLIENT_APP_XML:=$(SWF_DIR)$(CLIENT)-26app.xml
endif
FLEX_HOME:= $(HOME)/sdk/15
FLEX_HOME:= $(HOME)/flex_sdk_4.5
ifeq ($(EXE),true)
CLIENT_AIR:=$(APP_DIR)$(PROJECT).exe
FLEX_HOME:= $(HOME)/sdk/15
SERVER_APP_XML:=$(SWF_DIR)$(SERVER)-app.xml
CLIENT_APP_XML:=$(SWF_DIR)$(CLIENT)-app.xml
endif

ADL:= $(FLEX_HOME)/bin/adl
ADT:=$(FLEX_HOME)/bin/adt 
AMXMLC:= $(FLEX_HOME)/bin/amxmlc
MXMLC:= $(FLEX_HOME)/bin/amxmlc
SERVER_SWF:=$(SWF_DIR)$(SERVER).swf
SERVER_SWF1:=$(SWF_DIR)$(SERVER)1.swf
SERVER_SWF2:=$(SWF_DIR)$(SERVER)2.swf
SERVER_SWF3:=$(SWF_DIR)$(SERVER)3.swf
SERVER_SWF4:=$(SWF_DIR)$(SERVER)4.swf
CLIENT_SWF:=$(SWF_DIR)$(CLIENT).swf
CERT:=my.p12
PASSWORD:=db0@qq.com
RM:=rm -f
FLAGS:=-define=CONFIG::NET,$(NET) -define=CONFIG::debugging,$(debugging) -define=CONFIG::PUBLISH,$(PUBLISH) -define=CONFIG::FANTI,false

all:  $(SERVER_SWF1) # $(SERVER_SWF4) $(SERVER_SWF2) $(SERVER_SWF3)
#	$(CLIENT_AIR) $(CLIENT_APP_XML)
#	$(SERVER_AIR)
#	cp $(FDB).exe $(FLEX_HOME)/lib/fdb.exe
#	adb shell am start -a android.intent.action.VIEW -d  http://192.168.1.24:8809/smain.swf
	$(ADL) $(SERVER_APP_XML4)
	@echo "all ok"

$(SERVER_AIR): $(SERVER_SWF) $(SERVER_APP_XML)
ifeq ($(AIR),true)
	$(ADT) -package -storetype pkcs12 -tsa none -keystore $(CERT) -storepass $(PASSWORD) $(CLIENT_AIR) $(CLIENT)-26app.xml $(CLIENT).swf $(ASSET)
endif
ifeq ($(EXE),true)
	$(ADT) -package -storetype pkcs12 -keystore $(CERT) -tsa none -storepass $(PASSWORD) -target bundle $(CLIENT_AIR) $(CLIENT_APP_XML) $(CLIENT).swf $(ASSET)
endif
	$(ADL) $(CLIENT_APP_XML)
	@echo $(CLIENT_AIR) "is ok"

$(CLIENT_SWF): $(CLIENT_AS)
	$(MXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) $(FLAGS) $(AS_CLIENT) -source-path=$(AS_PATH) -debug=$(debugging) -output $(CLIENT_SWF)

$(SERVER_SWF1):$(SERVER_AS)
	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) $(FLAGS) $(AS_SERVER1) -source-path=$(AS_PATH) -debug=$(debugging) -output $(SERVER_SWF1)
#	$(ADL) $(SERVER_APP_XML1)

$(SERVER_SWF2):$(SERVER_AS)
	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) $(FLAGS) $(AS_SERVER2) -source-path=$(AS_PATH) -debug=$(debugging) -output $(SERVER_SWF2)
#	$(ADL) $(SERVER_APP_XML2)

$(SERVER_SWF3):$(SERVER_AS)
	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) $(FLAGS) $(AS_SERVER3) -source-path=$(AS_PATH) -debug=$(debugging) -output $(SERVER_SWF3)
#	$(ADL) $(SERVER_APP_XML3)

$(SERVER_SWF4):$(SERVER_AS)
	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) $(FLAGS) $(AS_SERVER4) -source-path=$(AS_PATH) -debug=$(debugging) -output $(SERVER_SWF4)
#	$(ADL) $(SERVER_APP_XML4)

$(SERVER_SWF):$(SERVER_AS)
	$(AMXMLC) -strict=true -metadata.publisher=libiao -omit-trace-statements=$(PUBLISH) -verbose-stacktraces=$(PUBLISH) $(FLAGS) $(AS_SERVER) -source-path=$(AS_PATH) -debug=$(debugging) -output $(SERVER_SWF)


$(CERT):
	$(ADT) -certificate -cn db0@qq.com -ou db0@qq.com -o db0@qq.com -c CN -validityPeriod 1 2048-RSA $(CERT) $(PASSWORD)


.PHONY : clean
clean:
	$(RM) $(CLIENT_AIR) $(SERVER_AIR) $(SERVER_SWF) $(CLIENT_SWF) $(WIN_ANE) $(EXE) $(ANE_DLL) abc $(ANE_SWC)
