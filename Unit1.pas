unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdHTTP, IdFTP, XPMan;

type
  TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    IdHTTP1: TIdHTTP;
    IdFTP1: TIdFTP;
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    Button2: TButton;
    XPManifest1: TXPManifest;
    Label3: TLabel;
    Label4: TLabel;
    Edit2: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure servidor(url:string);
    procedure salvar;
    procedure ftp(host:string;user:string;pass:string;nome:string);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
var
arquivo:string;
narq:string;


procedure TForm1.servidor(url:string);
 var
 nomeclean,strbruta:string;
 i:integer;

begin




try
 listbox1.clear;
 strbruta:=(memo1.text);
 for i := 0 to length(strbruta) do
   begin
    // if strbruta[i]='*' then

       if copy(strbruta,i,1)<>'*' then
       begin

        nomeclean:=nomeclean+copy(strbruta,i,1);
        end
        else
         begin
    listbox1.Items.Add(nomeclean);
    nomeclean:='';
end;
   end;
finally
 IdHTTP1.Free;
end;

for i := Listbox1.Items.Count - 1 downto 0 do
begin
if (Trim(Listbox1.Items[i]) = '') then
begin
Listbox1.Items.Delete(i);
end;
end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
if opendialog1.Execute then
arquivo:= opendialog1.filename;
narq:= extractfileName(OpenDialog1.FileName);
Memo1.Lines.LoadFromFile(arquivo);
servidor('http://www.url.com/'+narq);
label4.Caption:=narq+#13+'Frases Cadastradas:'+IntToStr(listbox1.Items.Count);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
memo1.Text:= memo1.Text+'*'+edit1.Text+'*';
salvar;
end;

procedure TForm1.ftp(host,user,pass,nome:string);
begin
IdFTP1.Disconnect();

IdFTP1.Host := host;
IdFTP1.Port := 21;
IdFTP1.Username := user;
IdFTP1.Password := pass;
IdFTP1.Passive := false; { usa modo ativo }
try
{ Espera até 10 segundos pela conexão }
button1.Enabled:=false;
button2.Enabled:=false;
IdFTP1.Connect(true, 1000);
IdFTP1.Put (arquivo, nome, false);
button1.Enabled:=true;
button2.Enabled:=true;
except
on E: Exception do
showmessage(E.Message);
end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
remov:string;
begin
remov:= '*'+Listbox1.Items[ListBox1.ItemIndex]+'*';

memo1.Text:= StringReplace(memo1.Text,remov,'',[rfReplaceAll]);
listbox1.DeleteSelected;
salvar;

end;

procedure TForm1.salvar;
begin
memo1.Lines.SaveToFile(arquivo);
ftp('ftp.address','user','Pass',edit2.text+narq);
memo1.Clear;
memo1.Lines.LoadFromFile(arquivo);
listbox1.Clear;
servidor('http://www.website.example/'+narq);
end;

end.