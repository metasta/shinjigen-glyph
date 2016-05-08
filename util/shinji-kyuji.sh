#!/bin/sh -
# usage: cat shinjigen.*.txt | sh shinji-kyuji.sh > shinji-kyuji.html

cat <<'EndOfHeader'
<!DOCTYPE html>
<meta charset="utf-8">
<meta name="viewport" content="initial-scale=0.9">
<title>表示確認（新字・旧字） | 旧字フォント 馬酔木明朝</title>
<link rel="stylesheet" href="/normalize.css">
<link rel="stylesheet" href="glyphtable.css">
<link id="webfont" href="https://ss1.xrea.com/metasta.s602.xrea.com/Asebi.css">
<link rel="icon" type="image/x-icon" href="https://assets-cdn.github.com/favicon.ico">
<main>
<nav id="menu">
<ul id="breadcrumb">
<li><a href="../..">馬酔木明朝</a>
<li><a href=".">表示確認（新字・旧字）</a>
</ul>
</nav>
<h1>表示確認（新字・旧字）</h1>
<p>『角川 新字源』（第24版、1997）で「旧字」表示のある897の字種が、馬酔木明朝（最新版）でどう見えるか。</p>
EndOfHeader

awk -F '	' \
'$6 == "新字"{
	s = $4
	k = $4
	t1 = $7
	t2 = $7
}
$6 == "旧字"{
	k = $4
	t2 = $7
	if (s == k){
		if (t1 == t2){
			print "<table><tr><td>"s"<tfoot><tr><th>"t1"</table>"
		} else {
			print "<table><tr><td>"s"<tfoot><tr><th>"t1"<br>"t2"</table>"
		}
	}
	else {
		if (t1 == t2){
			print "<table><tr><td>"s"<td>"k"<tfoot><tr><th colspan=2>"t1"</table>"
		} else {
			print "<table><tr><td>"s"<td>"k"<tfoot><tr><th colspan=2>"t1"<br>"t2"</table>"
		}
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
