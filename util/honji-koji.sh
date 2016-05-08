#!/bin/sh -
# usage: cat shinjigen.*.txt | sh honji-koji.sh > honji-koji.html

cat <<'EndOfHeader'
<!DOCTYPE html>
<meta charset="utf-8">
<meta name="viewport" content="initial-scale=0.9">
<title>表示確認（本字・古字） | 旧字フォント 馬酔木明朝</title>
<link rel="stylesheet" href="/normalize.css">
<link rel="stylesheet" href="glyphtable.css">
<link id="webfont" href="https://ss1.xrea.com/metasta.s602.xrea.com/Asebi.css">
<link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico">
<main>
<nav id="menu">
<ul id="breadcrumb">
<li><a href="../..">馬酔木明朝</a>
<li><a href=".">表示確認（本字・古字）</a>
</ul>
</nav>
<h1>表示確認（本字・古字）</h1>
<p>『角川 新字源』（第24版、1997）の「本字」「古字」が、馬酔木明朝（最新版）でどう見えるか。</p>
EndOfHeader

awk -F '	' \
'BEGIN { output = 0 }
$6 == "新字" || $6 == "親字" {
	if(output == 1){
		print "<table><tr>" glyph "<tfoot><tr>" text "</table>"
		output = 0
	}
	glyph = "<td>" $4
	text  = "<th>" $7
}
$6 == "本字" || $6 == "古字" {
	output = 1
	glyph = glyph "<td>" $4
	text  = text "<th>" $6 " " $7
}
END {
	if(output == 1){
		print "<table><tr>" glyph "<tfoot><tr>" text "</table>"
		output = 0
	}	
}'
cat <<'EndOfFooter'
</main>
<script>document.getElementById('webfont').rel = 'stylesheet';</script>
<script>
var table = document.getElementsByTagName('table');
for (var i = 0; i < table.length; i++){
	var tbody = table[i].firstChild;
	var clone = tbody.firstChild.cloneNode(true);
	clone.innerHTML = clone.innerHTML.replace(/[\*()]/g,"");
	tbody.appendChild(clone);
}
</script>
EndOfFooter
