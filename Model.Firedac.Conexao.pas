unit Model.Firedac.Conexao;

interface

uses
  System.Classes,

  //units necessárias para funcionamento do Firedac
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Comp.Client,
  FireDAC.Comp.UI, FireDAC.Stan.Param, FireDAC.DApt, FireDAC.comp.DataSet, FireDAC.Stan.Consts,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.IBWrapper,

  //units do Firedac para Postgres
  FireDAC.Phys.PG, FireDAC.Phys.PGDef,

  //units do Firedac para MSSQL
  FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQLWrapper,

  //units do Firedac para Firebird
  FireDAC.Phys.FB, FireDAC.Phys.FBDef,

  //para aplicações VCL
//  FireDAC.VCLUI.Wait,

  //para aplicações FireMonkey
//  FireDAC.FMXUI.Wait,

  //para o console / aplicações não-visuais}
  FireDAC.ConsoleUI.Wait;

type
  TTypeDatabase = (tbFirebird, tbOracle, tbMSSQL, tbPostgres, tbMySQL);

  TConexaoFiredac = class
  strict protected
    class var FInstance: TConexaoFiredac;
    class var FConectDef: IFDStanConnectionDef;
  private
    FDatabase: String;
    FUserName: String;
    FPassword: String;
    FDriverID: TTypeDatabase;
    FServer: String;
    FPorta: Integer;
    FSchema: String;
    FPooled: Boolean;
    procedure CarregarParametros;
    procedure ConfigurarManager;
    constructor CreatePrivate;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: TConexaoFiredac;
    property DriverId: TTypeDatabase read FDriverID;
  end;

var
  ConexaoFiredac: TConexaoFiredac;

const
  cCONECTION_NAME = 'CONEXAO_SERVIDOR_DMVC';

implementation

uses
  System.SysUtils,
  System.TypInfo,
  Config.Server;
//  , IWSystem;

{ TConexaoFiredac }

constructor TConexaoFiredac.Create;
begin
  raise Exception.Create('Não é possível criar objeto de conexão. Utilze TConexaoFiredac.New');
end;

constructor TConexaoFiredac.CreatePrivate;
begin
  inherited Create;
  ConfigurarManager;
end;

destructor TConexaoFiredac.Destroy;
begin
  inherited;
end;

class function TConexaoFiredac.New: TConexaoFiredac;
begin
  if not Assigned(FInstance) then
    FInstance := Self.CreatePrivate;

  Result := FInstance;
end;

procedure TConexaoFiredac.CarregarParametros;
var
  TypeBD: String;
begin
    TypeBD := 'tb' + UpperCase(ConfigServer.BD_Type);
    FDriverID := TTypeDatabase(GetEnumValue(TypeInfo(TTypeDatabase), TypeBD));
    FServer := ConfigServer.BD_Server;
    FPorta := ConfigServer.BD_Port;
    FSchema := ConfigServer.BD_Schema;
    FDatabase := ConfigServer.BD_DatabaseName;
    FUserName := ConfigServer.BD_UserName;
    FPassword := ConfigServer.BD_Password;
    FPooled := ConfigServer.BD_Pooled;
end;

procedure TConexaoFiredac.ConfigurarManager;
begin
  CarregarParametros;

  FConectDef := FDManager.ConnectionDefs.AddConnectionDef;
  FConectDef.Name := cCONECTION_NAME;
  case FDriverID of
    tbFirebird: FConectDef.Params.DriverID := 'FB';
    tbOracle: FConectDef.Params.DriverID := 'Ora';
    tbMSSQL: FConectDef.Params.DriverID := 'MSSQL';
    tbPostgres: FConectDef.Params.DriverID := 'PG';
    tbMySQL: FConectDef.Params.DriverID := 'MySQL';
  end;

  FConectDef.AsString[S_FD_ConnParam_Common_Server] := FServer;
  if FPorta > varEmpty then
    FConectDef.AsInteger[S_FD_ConnParam_Common_Port] := FPorta;
  FConectDef.Params.Database := FDatabase;
  FConectDef.Params.UserName := FUserName;
  FConectDef.Params.Password := FPassword;
  FConectDef.Params.Pooled := FPooled;

  //parametros para o controle do pool se necessário e quiser alterar
//  FConectDef.Params.PoolMaximumItems := 50;
//  FConectDef.Params.PoolExpireTimeout := 9000;
//  FConectDef.Params.PoolCleanupTimeout := 900000;
end;

initialization
  ConexaoFiredac := TConexaoFiredac.New;

finalization
  ConexaoFiredac.DisposeOf;

end.
