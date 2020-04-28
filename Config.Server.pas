unit Config.Server;

interface

uses
  System.IniFiles;

type
  TConfigServer = class(TIniFile)
  const
    S_DATABASE = 'DATABASE';
  private
    FBDType: String;
    FBDConectionName: String;
    FBDServer: String;
    FBDPort: Integer;
    FBDSchema: String;
    FBDDatabaseName: String;
    FBDUserName: String;
    FBDPassword: String;
    FBDPooled: Boolean;

    procedure SetBDType(const Value: String);
    procedure SetBDServer(const Value: String);
    procedure SetBDPort(const Value: Integer);
    procedure SetBDSchema(const Value: String);
    procedure SetBDDatabaseName(const Value: String);
    procedure SetBDUserName(const Value: String);
    procedure SetBDPassword(const Value: String);
    procedure SetBDPooled(const Value: Boolean);
    function GetBDDatabaseName: String;
    function GetBDPassword: String;
    function GetBDPooled: Boolean;
    function GetBDPort: Integer;
    function GetBDSchema: String;
    function GetBDServer: String;
    function GetBDType: String;
    function GetBDUserName: String;
  public
    property BD_Type: String read GetBDType write SetBDType;
    property BD_Server: String read GetBDServer write SetBDServer;
    property BD_Port: Integer read GetBDPort write SetBDPort;
    property BD_Schema: String read GetBDSchema write SetBDSchema;
    property BD_DatabaseName: String read GetBDDatabaseName write SetBDDatabaseName;
    property BD_UserName: String read GetBDUserName write SetBDUserName;
    property BD_Password: String read GetBDPassword write SetBDPassword;
    property BD_Pooled: Boolean read GetBDPooled write SetBDPooled;
  end;

var
  ConfigServer: TConfigServer;

implementation

uses
  System.SysUtils;

{ TConfigServer }

{$REGION 'Database'}
function TConfigServer.GetBDType: String;
begin
  Result := Self.ReadString(S_DATABASE, 'TypeDB', '');
end;

function TConfigServer.GetBDServer: String;
begin
  Result := Self.ReadString(S_DATABASE, 'Host', '');
end;

function TConfigServer.GetBDPort: Integer;
begin
  Result := Self.ReadInteger(S_DATABASE, 'Port', 0);
end;

function TConfigServer.GetBDSchema: String;
begin
  Result := Self.ReadString(S_DATABASE, 'Schema', '');
end;

function TConfigServer.GetBDDatabaseName: String;
begin
  Result := Self.ReadString(S_DATABASE, 'DatabaseName', '');
end;

function TConfigServer.GetBDUserName: String;
begin
  Result := Self.ReadString(S_DATABASE, 'UserName', '');
end;

function TConfigServer.GetBDPassword: String;
begin
  Result := Self.ReadString(S_DATABASE, 'Password', '');
end;

function TConfigServer.GetBDPooled: Boolean;
begin
  Result := Self.ReadBool(S_DATABASE, 'Pooled', True);
end;

procedure TConfigServer.SetBDType(const Value: String);
begin
  Self.WriteString(S_DATABASE, 'TypeDB', Value);
end;

procedure TConfigServer.SetBDServer(const Value: String);
begin
  Self.WriteString(S_DATABASE, 'Host', Value);
end;

procedure TConfigServer.SetBDPort(const Value: Integer);
begin
  Self.WriteInteger(S_DATABASE, 'Port', Value);
end;

procedure TConfigServer.SetBDSchema(const Value: String);
begin
  Self.WriteString(S_DATABASE, 'Schema', Value);
end;

procedure TConfigServer.SetBDDatabaseName(const Value: String);
begin
  Self.WriteString(S_DATABASE, 'DatabaseName', Value);
end;

procedure TConfigServer.SetBDUserName(const Value: String);
begin
  Self.WriteString(S_DATABASE, 'UserName', Value);
end;

procedure TConfigServer.SetBDPassword(const Value: String);
begin
  Self.WriteString(S_DATABASE, 'Password', Value);
end;

procedure TConfigServer.SetBDPooled(const Value: Boolean);
begin
  Self.WriteBool(S_DATABASE, 'Pooled', Value);
end;
{$ENDREGION}

initialization
  ConfigServer := TConfigServer.Create(ChangeFileExt(ParamStr(0), '.ini'));

finalization
  ConfigServer.Free;

end.
