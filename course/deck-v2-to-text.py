import json, html, pathlib, re
from html.parser import HTMLParser

class S(HTMLParser):
    def __init__(self):
        super().__init__(convert_charrefs=True)
        self.out=[]; self.stack=[]; self.buf=""; self.row=None; self.table=None
        self.aside=None; self.incell=False
    def flush(self, tag):
        t=re.sub(r"\s+"," ",self.buf).strip(); self.buf=""
        return t
    def handle_starttag(self, tag, attrs):
        a=dict(attrs)
        if tag in ("h1","h2","h3","p","li","aside"): self.buf=""
        if tag=="table": self.table=[]
        if tag=="tr": self.row=[]
        if tag in ("td","th"): self.buf=""; self.incell=True
        if tag=="b": self.buf+="**"
        if tag=="i": self.buf+="_"
    def handle_endtag(self, tag):
        if tag=="b": self.buf+="**"
        if tag=="i": self.buf+="_"
        if tag in ("td","th"):
            self.row.append(self.flush(tag).replace("|","\\|")); self.incell=False
        elif tag=="tr":
            self.table.append(self.row); self.row=None
        elif tag=="table":
            t=self.table
            if t:
                w=max(len(r) for r in t)
                for r in t: r += [""]*(w-len(r))
                self.out.append("| "+" | ".join(t[0])+" |")
                self.out.append("|"+"---|"*w)
                for r in t[1:]: self.out.append("| "+" | ".join(r)+" |")
                self.out.append("")
            self.table=None
        elif tag in ("h1","h2"):
            self.out.append("### "+self.flush(tag)); self.out.append("")
        elif tag=="h3":
            self.out.append("**"+self.flush(tag)+"**"); self.out.append("")
        elif tag=="p":
            t=self.flush(tag)
            if t: self.out.append(t); self.out.append("")
        elif tag=="li":
            self.out.append("- "+self.flush(tag))
        elif tag=="aside":
            self.aside=self.flush(tag)
    def handle_data(self, d):
        self.buf+=d

d=json.loads(pathlib.Path("project/deck.json").read_text())
lines=["# The Loop V2 — full text for markup",
"",
"Every word that appears on a slide, plus the speaker notes, in deck order. Edit this file directly, or leave a line starting with `>>` under anything you want changed. When the verbiage is settled it goes back into the slides.",
"",
f"**{len(d['order'])} slides.** Artifact: https://claude.ai/artifact/2LkUiqh4HdXATQUhNBCy9J",
"","---",""]
for i,sid in enumerate(d["order"],1):
    p=SP=pathlib.Path("project/slides/%s.html"%sid)
    s=S(); s.feed(p.read_text())
    lines.append(f"## {i}. `{sid}`"); lines.append("")
    body=[x for x in s.out]
    while body and body[-1]=="": body.pop()
    lines += body
    lines.append("")
    lines.append("**Speaker notes.** "+(s.aside or "_none_"))
    lines.append(""); lines.append("---"); lines.append("")
pathlib.Path("/Users/thechrisoneil/software/agentic-loop/course/deck-v2.md").write_text("\n".join(lines)+"\n")
print("wrote deck-v2.md")
