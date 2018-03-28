#!/bin/bash
for i in {2009..2018}; do
  mkdir "$i" && cd "$i" 
  pre_url="http://riotransparente.rio.rj.gov.br/favorecidos/pagamento_orcamentario/resposta1Export.asp?favorecido=&tipoExportacao=csv&EXERCICIO="
  ano="$i" &&  export ano="$i"
  url_ano="$pre_url$ano&CNPJ="
        for i in {0..9}; do 
        arquivo=$(echo "$i-$ano.csv")
        url=$(echo "$url_ano$i")
        wget -O "$arquivo" -nc "$url";
        sed -i 1d "$arquivo" 
        done
   cat * > "$ano-dupli.csv" 
   sort --field-separator=';' -u "$ano-dupli.csv" > "$ano-bruto.csv"
   dos2unix "$ano-bruto.csv"
   awk 'BEGIN { OFS = ";" } {print $0, "'$ano'"}' "$ano-bruto.csv" > "$ano.csv"
   mv "$ano.csv" .. && cd ..
done
cat *.csv > orcamento.csv 