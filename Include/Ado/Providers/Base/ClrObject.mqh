//+------------------------------------------------------------------+
//|                                                    ClrObject.mqh |
//|                                             Copyright GF1D, 2010 |
//|                                             garf1eldhome@mail.ru |
//+------------------------------------------------------------------+
#property copyright "GF1D, 2010"
#property link      "garf1eldhome@mail.ru"

#include "..\..\AdoErrors.mqh"

//--------------------------------------------------------------------
#import "AdoSuite.dll"
long CreateManagedObject(const string,const string,string&,string&);
void DestroyManagedObject(const long,string&,string&);
#import
//--------------------------------------------------------------------
/// \brief  \~russian Îáúåêò èñïîëíÿþùåé ñðåäû .NET.
///         \~english Represents CLR Object.
///
/// \~russian Ñîäåðæèò íåîáõîäèìûå ìåòîäû äëÿ ñîçäàíèÿ è óíè÷òîæåíèÿ óïðàâëÿåìûõ îáúåêòîâ, îáðàáîòêè èñêëþ÷åíèé ïðè âûçîâå. ßâëÿåòñÿ áàçîâûì êëàñîì
/// \~english Includes neccessary methods for creating and disposing managed objects, exception handling. Abstract class
class CClrObject
  {
private:
   // variables
   bool              _IsCreated,_IsAssigned;
   long              _ClrHandle;
   string            _MqlTypeName;

protected:

   // properties

   /// \brief  \~russian Âîçâðàùàåò èìÿ òèïà, êîòîðûé ïðåäñòàâëÿåò ïðîèçâîäíûé êëàññ
   ///         \~english Gets type string of inherited class
   const string MqlTypeName() { return _MqlTypeName; }
   /// \brief  \~russian Óñòàíàâëèâàåò èìÿ òèïà, êîòîðûé ïðåäñòàâëÿåò ïðîèçâîäíûé êëàññ
   ///         \~english Sets type string of inherited class
   void MqlTypeName(const string value) { _MqlTypeName=value; }

   // methods

   /// \brief  \~russian Ñîçäàåò îáúåêò CLR 
   ///         \~english Creates CLR object
   /// \~russian \param  asmName   èìÿ ñáîðêè. Èñïîëüçóåòñÿ êîðîòêîå èìÿ ñáîðêè: System, System.Data è ò ï 
   /// \~english \param  asmName   short assembly name: System, System.Data etc
   /// \~russian \param  typeName  ïîëíîå èìÿ òèïà: System.String, System.Data.DataTable è ò ï
   /// \~english \param  typeName  full type name eg System.String, System.Data.DataTable etc
   void              CreateClrObject(const string asmName,const string typeName);
   /// \brief  \~russian Óíè÷òîæàåò îáúåêò CLR. Àâòîìàòè÷åñêè âûçûâàåòñÿ â äåñòðóêòîðå, ïîýòîìó ÿâíî âûçûâàòü íå íóæíî!
   ///         \~english Destroys CLR object. Called automatically in desctructor, so dont call it explictly!
   void              DestroyClrObject();

   // events

   /// \brief  \~russian Âûçûâàåòñÿ ïåðåä òåì êàê îáúåêò áóäåò ñîçäàí. Âèðòóàëüíûé ìåòîä
   ///         \~english Called before object is being created. Virtual
   /// \~russian \param isCanceling  ïåðåìåííàÿ bool, ïåðåäàþùàÿñÿ ïî cñûëêå. Åñëè óñòàíîâèòü çíà÷åíèå false, òî ñîçäàíèå îáúåêòà áóäåò ïîäàâëåíî
   /// \~english \param isCanceling  bool variable, passed by a reference. If set value to false, then object creation will be suppressed
   /// \~russian \param creating    true - åñëè îáúåêò ñîçäàåòñÿ, false - åñëè îáúåêò ïðèñâàèâàåòñÿ ÷åðåç ôóíêöèþ CClrObject::Assign
   /// \~english \param creating    when true indicates that object is creating, otherwise object is assigning using CClrObject::Assign
   virtual void OnObjectCreating(bool &isCanceling,bool creating=true) {}
   /// \brief  \~russian Âûçûâàåòñÿ ïîñëå òîãî, êàê Clr îáúåêò ñîçäàí. Âèðòóàëüíûé ìåòîä
   ///         \~english Called after CLR object was created
   virtual void OnObjectCreated() {}
   /// \brief  \~russian Âûçûâàåòñÿ ïåðåä òåì, êàê Clr îáúåêò áóäåò óíè÷òîæåí. Âèðòóàëüíûé ìåòîä
   ///         \~english Called before object is being destroyed. Virtual
   virtual void OnObjectDestroying() {}
   /// \brief  \~russian Âûçûâàåòñÿ ïîñëå òîãî, êàê Clr îáúåêò óíè÷òîæåí. Âèðòóàëüíûé ìåòîä
   ///         \~english Called after CLR object was destroyed
   virtual void OnObjectDestroyed() {}

   /// \brief  \~russian Âûçûâàåòñÿ â ñëó÷àå èñêëþ÷åíèÿ(îøèáêè). Âèðòóàëüíûé ìåòîä.
   ///         \~english Called when an exception occurs. Virtual
   /// \~russian \param method    èìÿ ìåòîäà, â êîòîðîì ïðîèçîøëî èñêëþ÷åíèå
   /// \~english \param method    method name where the exception was thrown
   /// \~russian \param type      òèï èñêëþ÷åíèÿ. Îáû÷íî îäèí èç .NET òèïîâ 
   /// \~english \param type      exception type. Usually one of .NET types
   /// \~russian \param message   ïîäðîáíàÿ èíôîðìàöèÿ îá îøèáêå 
   /// \~english \param message   exception message. Describes error details
   /// \~russian \param mqlErr    îøèáêà mql, ñîîòâåòñòâóþùàÿ äàííîìó èñêëþ÷åíèþ. Ïî óìîë÷àíèþ ADOERR_FIRST  
   /// \~english \param mqlErr    appropriate mql error equivalent. ADOERR_FIRST by default
   virtual void      OnClrException(const string method,const string type,const string message,const ushort mqlErr);

public:
   /// \brief  \~russian êîíñòðóêòîð êëàññà
   ///         \~english constructor
                     CClrObject() { _MqlTypeName="CClrObject"; }
   /// \brief  \~russian äåñòðóêòîð êëàññà
   ///         \~english destructor
                    ~CClrObject() { DestroyClrObject(); }

   // properties

   /// \brief  \~russian Âîçâðàùàåò óêàçàòåëü íà GCHandle, ñîäåðæàùèé îáúåêò
   ///         \~english Returns pointer for GCHandle, catching the object
   const long ClrHandle() { return _ClrHandle; }
   /// \brief  \~russian Âîçâðàùàåò true åñëè îáúåêò áûë ïðèñâîåí, â ïðîòèâíîì ñëó÷àå false
   ///         \~english Indicates whether object was assigned
   const bool IsAssigned() { return _IsAssigned; }
   /// \brief  \~russian Âîçâðàùàåò true åñëè îáúåêò áûë ñîçäàí èç mql êîäà, â ïðîòèâíîì ñëó÷àå false
   ///         \~english Indicates whether object was created
   const bool IsCreated() { return _IsCreated; }

   // methods

   /// \brief  \~russian Ïðèñâÿçûâàåò îáúåêò ê óæå ñîçäàííîìó îáúåêòó CLR 
   ///         \~english Assigns this object to an existing CLR object
   /// \~russian \param handle       óêàçàòåëü íà GCHanlde, ñîäåðæàùèé îáúåêò 
   /// \~english \param handle       pointer to GCHanlde with object
   /// \~russian \param autoDestroy  true - åñëè CLR îáúåêò íåîáõîäèìî óíè÷òîæèòü ñ óíè÷òîæåíèåì ñîîòâåòñòâóþùåãî ÑÑlrObject, false - åñëè îáúåêò íóæíî îñòâàèòü â ïàìÿòè. Ïî óìîë÷àíèþ false.
   /// \~english \param autoDestroy  Indicates whether CLR object has to be destroyed with appropriate ÑÑlrObject
   void              Assign(const long handle,const bool autoDestroy);
  };
//--------------------------------------------------------------------
void CClrObject::CreateClrObject(const string asmName,const string typeName)
  {
   bool isCanceling=false;

   OnObjectCreating(isCanceling,true);

   if(isCanceling) return;

   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   _ClrHandle=CreateManagedObject(asmName,typeName,exType,exMsg);

   if(exType!="")
     {
      _IsCreated=false;
      OnClrException("CreateClrObject",exType,exMsg);
     }
   else _IsCreated=true;
   _IsAssigned=false;

   OnObjectCreated();

  }
//--------------------------------------------------------------------
void CClrObject::DestroyClrObject(void)
  {
   if(!_IsCreated) return;

   OnObjectDestroying();

   string exType="",exMsg="";
   StringInit(exType,64);
   StringInit(exMsg,256);

   DestroyManagedObject(_ClrHandle,exType,exMsg);

   _IsCreated=false;

   if(exType!="")
      OnClrException("DestroyClrObject",exType,exMsg);

   OnObjectDestroyed();
  }
//--------------------------------------------------------------------
void CClrObject::Assign(const long handle,const bool autoDestroy=false)
  {
   bool isCanceling=false;
   OnObjectCreating(isCanceling,false);

   if(isCanceling) return;

   _ClrHandle = handle;
   _IsCreated = autoDestroy;
   _IsAssigned= true;

   OnObjectCreated();
  }
//--------------------------------------------------------------------
void CClrObject::OnClrException(const string method,const string type,const string message,const ushort mqlErr=ADOERR_FIRST)
  {
   Alert("Ìåòîä ",_MqlTypeName,"::",method," âûäàë èñêëþ÷åíèå òèïà ",type,":\r\n",message);
   SetUserError(mqlErr);
  }
//+------------------------------------------------------------------+
