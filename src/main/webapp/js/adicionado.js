const params = new URLSearchParams(window.location.search);
const msg = params.get("mensagem");

if (msg === "adicionado") {
    alert("Prato adicionado ao carrinho!");
}