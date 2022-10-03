document.getElementById('hablar').addEventListener("click",()=>{
    decir(document.getElementById("texto").value);
});

function soundvoice(resid){
    decir(document.getElementById("texto"+resid).value);
}

function decir(texto){
    speechSynthesis.speak(new SpeechSynthesisUtterance(texto));
}
