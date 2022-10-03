function redireccionar(){
    window.location='index.php';
}
function redireccionar_reporte(dato){
    window.location=dato;
}
function redireccionar_menu(){
    window.location='../../menu/MenuSistema.php';
}
function LlamarReporte(id){
    alert("si");
    $.ajax({
        url: '../../reportes/individuales/cliente.php',
        type: "GET",
        data: "id="+id,
        success: function(datos){
            alert(datos);
        }
    });
    return false;
}
function Validar_registro(){
    var cedula =  document.getElementById('cedula').value;
    if(verificador_identificativo(cedula)==false){
        alert("RUC o Cédula es incorrecto.");
        return false;
    }
    return true;
}
function Validar_registro_dni(){
    var dni =  document.getElementById('dni').value;
    if(verificador_identificativo(dni)==false){
        alert("RUC o Cédula es incorrecto.");
        return false;
    }
    return true;
}
function Validar_registro2(){
    var  cedula2 =  document.getElementById('cedula2').value;
    var  clave2 =  document.getElementById('clave2').value;
    var  rclave2 =  document.getElementById('rclave2').value;
    if(clave2!=rclave2){
        alert("Claves no coinciden");
        return false;
    }
    if(fortalecer_clave(clave2)==false){
        return false;
    }
    if(verificador_identificativo(cedula2)==false){
        alert("Cedula incorrecta");
        return false;
    }
    return true;
}
function Validar_registro3(){
    var  clave2 =  document.getElementById('clave2').value;
    var  rclave2 =  document.getElementById('rclave2').value;
    if(clave2!=rclave2){
        alert("Claves no coinciden");
        return false;
    }
    if(fortalecer_clave(clave2)==false){
        return false;
    }
    return true;
}
function Validar_registrocliente(){
    var  cedula =  document.getElementById('cedula').value;
    var  clave2 =  document.getElementById('clave2').value;
    var  rclave2 =  document.getElementById('rclave2').value;
    if(clave2!=rclave2){
        alert("Claves no coinciden");
        return false;
    }
    if(fortalecer_clave(clave2)==false){
        return false;
    }
    if(verificador_identificativo(cedula)==false){
        alert("Cedula incorrecta");
        return false;
    }
    return true;
}

/*validar stock*/
function ValidarRegistroStock(elem) {
    //   debugger;
    //   var stockElem = elem[5];
    var cantidad_bodega = elem[3].value;
    var cantidad_ingresada = elem[5].value;
    if (parseInt(cantidad_ingresada) == 0) {
        alert("La cantidad ingresada no puede ser cero.");
        window.location = location.pathname + location.search;
        return false;
    }
    if (parseInt(cantidad_ingresada) > parseInt(cantidad_bodega)) {
        alert("La cantidad ingresada (" + cantidad_ingresada + ") es mayor que el stock (" + cantidad_bodega+ ").");
        window.location = location.pathname + location.search;
        return false;
    }
    return true;
}
