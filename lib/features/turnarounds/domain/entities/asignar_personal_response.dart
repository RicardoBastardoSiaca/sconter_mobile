
// To parse this JSON data, do
//
//     final asignarPersonalResponse = asignarPersonalResponseFromJson(jsonString);

// import 'dart:convert';

// AsignarPersonalResponse asignarPersonalResponseFromJson(String str) => AsignarPersonalResponse.fromJson(json.decode(str));

// String asignarPersonalResponseToJson(AsignarPersonalResponse data) => json.encode(data.toJson());

class AsignarPersonalResponse {
    bool crear;
    bool modificar;
    int idTurnaround;
    String horaI;
    String horaF;
    String fecha;
    List<DepartamentosCerrar> departamentosPersonal;
    List<DepartamentosCerrar> departamentosFirma;
    List<DepartamentosCerrar> departamentosCerrar;
    List<DepartamentosCerrar> gerenteTurno;
    List<DepartamentosCerrar> supervisor;

    AsignarPersonalResponse({
        required this.crear,
        required this.modificar,
        required this.idTurnaround,
        required this.horaI,
        required this.horaF,
        required this.fecha,
        required this.departamentosPersonal,
        required this.departamentosFirma,
        required this.departamentosCerrar,
        required this.gerenteTurno,
        required this.supervisor,
    });

    // factory AsignarPersonalResponse.fromJson(Map<String, dynamic> json) => AsignarPersonalResponse(
    //     crear: json["crear"],
    //     modificar: json["modificar"],
    //     idTurnaround: json["id_turnaround"],
    //     horaI: json["horaI"],
    //     horaF: json["horaF"],
    //     fecha: json["fecha"],
    //     departamentosPersonal: List<DepartamentosCerrar>.from(json["departamentos_personal"].map((x) => DepartamentosCerrar.fromJson(x))),
    //     departamentosFirma: List<DepartamentosCerrar>.from(json["departamentos_firma"].map((x) => DepartamentosCerrar.fromJson(x))),
    //     departamentosCerrar: List<DepartamentosCerrar>.from(json["departamentos_cerrar"].map((x) => DepartamentosCerrar.fromJson(x))),
    //     gerenteTurno: List<DepartamentosCerrar>.from(json["gerente_turno"].map((x) => DepartamentosCerrar.fromJson(x))),
    //     supervisor: List<DepartamentosCerrar>.from(json["supervisor"].map((x) => DepartamentosCerrar.fromJson(x))),
    // );

    // Map<String, dynamic> toJson() => {
    //     "crear": crear,
    //     "modificar": modificar,
    //     "id_turnaround": idTurnaround,
    //     "horaI": horaI,
    //     "horaF": horaF,
    //     "fecha": fecha,
    //     "departamentos_personal": List<dynamic>.from(departamentosPersonal.map((x) => x.toJson())),
    //     "departamentos_firma": List<dynamic>.from(departamentosFirma.map((x) => x.toJson())),
    //     "departamentos_cerrar": List<dynamic>.from(departamentosCerrar.map((x) => x.toJson())),
    //     "gerente_turno": List<dynamic>.from(gerenteTurno.map((x) => x.toJson())),
    //     "supervisor": List<dynamic>.from(supervisor.map((x) => x.toJson())),
    // };
}

class DepartamentosCerrar {
    String nombreDepartamento;
    List<Personal> personal;

    DepartamentosCerrar({
        required this.nombreDepartamento,
        required this.personal,
    });

//     factory DepartamentosCerrar.fromJson(Map<String, dynamic> json) => DepartamentosCerrar(
//         nombreDepartamento: json["nombre_departamento"],
//         personal: List<Personal>.from(json["personal"].map((x) => Personal.fromJson(x))),
//     );

//     Map<String, dynamic> toJson() => {
//         "nombre_departamento": nombreDepartamento,
//         "personal": List<dynamic>.from(personal.map((x) => x.toJson())),
//     };
}

class Personal {
    int id;
    String nombre;
    String cedula;
    String correo;
    String telefono;
    String cargo;
    bool ocupado;
    bool selected;

    Personal({
        required this.id,
        required this.nombre,
        required this.cedula,
        required this.correo,
        required this.telefono,
        required this.cargo,
        required this.ocupado,
        required this.selected,
    });

    // factory Personal.fromJson(Map<String, dynamic> json) => Personal(
    //     id: json["id"],
    //     nombre: json["nombre"],
    //     cedula: json["cedula"],
    //     correo: json["correo"],
    //     telefono: json["telefono"],
    //     cargo: json["cargo"],
    //     ocupado: json["ocupado"],
    //     selected: json["selected"],
    // );

    // Map<String, dynamic> toJson() => {
    //     "id": id,
    //     "nombre": nombre,
    //     "cedula": cedula,
    //     "correo": correo,
    //     "telefono": telefono,
    //     "cargo": cargo,
    //     "ocupado": ocupado,
    //     "selected": selected,
    // };
}
