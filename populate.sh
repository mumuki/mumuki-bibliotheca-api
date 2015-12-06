for i in \
"pdep-utn/mumuki-logico-tp-sturbacks" \
"mumuki/guia-funcional-javascript-1" \
"pdep-utn/mumuki-funcional-guia-1" \
"pdep-utn/mumuki-logico-guia-1" \
"pdep-utn/mumuki-logico-guia-3" \
"pdep-utn/mumuki-funcional-guia-2"-orden-superior \
"pdep-utn/mumuki-funcional-guia-3" \
"pdep-utn/mumuki-logico-guia-2" \
"mumuki/mumuki-objetos-javascript-guia-1" \
"mumuki/mumuki-objetos-ruby-guia-1" \
"pdep-utn/mumuki-logico-tp-teg" \
"mumuki/mumuki-objetos-ruby-guia-0" \
"pdep-utn/mumuki-funcional-guia-5-modelado" \
"pdep-utn/mumuki-funcional-tp-chocobos" \
"pdep-utn/mumuki-logico-tp-los-topos" \
"mumuki/mumuki-objetos-javascript-guia-0" \
"mumuki/mumuki-guia-desafios-javascript" \
"pdep-utn/mumuki-logico-apunte-functores" \
"sagrado-corazon-alcal/mumuki-fundamentos-gobstones-guia-2-procedimientos" \
"pdep-utn/mumuki-funcional-guia-2-listas-compresion" \
"pdep-utn/mumuki-funcional-guia-4-tipos" \
"pdep-utn/mumuki-funcional-guia-4-lambda" \
"sagrado-corazon-alcal/mumuki-fundamentos-gobstones-guia-3-repeticion-simple" \
"pdep-utn/mumuki-funcional-guia-0" \
"mumuki/mumuki-guia-desafios-gobstones" \
"sagrado-corazon-alcal/mumuki-fundamentos-gobstones-tp-procedimientos" \
"gcrespi/mumuki-logico-pulp-fiction" \
"arquitecturas-concurrentes/mumuki-funcional-guia-monadas" \
"sagrado-corazon-alcal/mumuki-fundamentos-gobstones-guia-1-primeros-programas"; do
  curl -X POST http://bibliotheca.mumuki.io/guides/import/$i
done
