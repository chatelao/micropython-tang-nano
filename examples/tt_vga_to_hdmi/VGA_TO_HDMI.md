Gemini hat gesagt
Die Portierung eines "Tiny Tapeout" (TT) VGA-Designs aus dem "VGA-Playground" auf den Tang Nano 4K mit nativer HDMI-Ausgabe (und Audio) ist ein faszinierendes Projekt für Ingenieure, die sich für Hochgeschwindigkeits-Schnittstellen und TMDS-Encoding auf der Logikebene interessieren.

Es gibt dafür glücklicherweise bereits exzellente Open-Source-Bausteine, die kombiniert werden müssen. Die direkte Umsetzung erfordert jedoch eine saubere Takt-Domänen-Trennung und ein Verständnis dafür, wie FPGAs differentielle Signale emulieren.

Im Folgenden findest Du den strukturierten Architektur- und Kritiküberblick in der geforderten Einzeltabelle, gefolgt von einer Verilog-Implementierung, die als Wrapper ("Top-Level") zwischen dem TT-Design, der Gowin-Hardware und einem Open-Source HDMI-Core fungiert.

Architektur, Quellen & Kritische Analyse
Kategorie	Beschreibung & Verifikation	Geprüfte Quelle (URL/Buch)	Persona-Kritik (Gordon Ramsay / Red Team / Devil's Advocate)
VGA-Basis (Tiny Tapeout)	Der VGA-Playground generiert rohe hsync, vsync und Farbkanäle (meist 2-bit pro Kanal: rrggbb). Diese sind nicht für TMDS (HDMI) formatiert und haben eine Basis-Taktung (oft 25.175 MHz für 640x480).	TinyTapeout VGA Playground	Devil's Advocate: Warum der HDMI-Overhead? Ein ASIC-Tapeout nutzt physikalische R2R-Widerstandsnetzwerke für echtes VGA. Das Testen über HDMI auf dem FPGA verfälscht das Timing-Verhalten und verschwendet Logik, die Du für das eigentliche ASIC-Design evaluieren solltest.
HDMI-Video-Encoder (TMDS)	Umwandlung von 24-Bit		
Du hast diese Antwort angehalten
Du hast gesagt
Gibt es bereits Open-Source Verilog code, der VGA signale der Tiny Tapeout Verilog "demo" Designs in HDMI signale auf einem Tang Nano 4k umwandeln könnte? Idealerweise sogar mit dem Audiokanal. Schaue dabei auch auf den vom "VGA-Playground" generierten Code.

Gemini hat gesagt
Hier ist der Plan, den ich erstellt habe. Gib Bescheid, falls du Änderungen benötigst, bevor ich mit der Recherche beginne.
 Verilog: VGA zu HDMI Tang Nano 
Recherche-Websites
(1) Suche nach Open-Source Verilog-Projekten und Repositories, die VGA-Signale in HDMI- oder DVI-Signale konvertieren und speziell für das Tang Nano 4k (Gowin FPGA) portiert wurden.
(2) Recherchiere die Spezifikationen der VGA-Signale (Auflösung, Timing, Pixeltakt), die typischerweise von den Tiny Tapeout Verilog "demo" Designs ausgegeben werden.
(3) Untersuche den "VGA-Playground", um die Struktur des dort generierten Verilog-Codes zu analysieren und zu prüfen, ob direkte Schnittstellen oder Module für HDMI/TMDS-Encoding existieren.
(4) Suche nach HDMI-Transmitter-Implementierungen in Verilog für die Tang Nano Serie, die das Einbetten von Audio-Datenpaketen (Audio Data Islands) in den TMDS-Datenstrom unterstützen.
(5) Vergleiche die Anforderungen der gefundenen Tang Nano 4k HDMI-Module mit den generierten VGA-Signalen aus den Tiny Tapeout Demos und dem VGA-Playground.
(6) Fasse zusammen, wie diese Komponenten kombiniert werden können, um ein funktionierendes Gesamtsystem inklusive Audiokanal zu erstellen, und identifiziere eventuelle fehlende Zwischenmodule (z.B. Taktgeber oder PLLs für den Gowin FPGA).
Analysiere Ergebnisse
Erstelle Bericht
In wenigen Minuten fertig

Du hast gesagt
Recherche starten

Gemini hat gesagt
Ich bin mit deiner Recherche fertig. Du kannst mir gerne Folgefragen stellen oder Änderungen anfordern.
Verilog: VGA zu HDMI Tang Nano
Abgeschlossen
29. März, 20:21

Du hast gesagt
gib mir den bericht als markdown

Gemini hat gesagt
Hier ist der gewünschte Bericht im reinen Markdown-Format:

Systemarchitektur und Open-Source-Verilog-Ressourcen für die Konvertierung von Tiny-Tapeout-VGA- und Audiosignalen zu HDMI auf dem Tang Nano 4K
Einleitung und Problemstellung
Die Entwicklung von anwendungsspezifischen integrierten Schaltungen (ASICs) hat durch kollaborative Initiativen wie Tiny Tapeout eine tiefgreifende Demokratisierung erfahren. Diese Plattform ermöglicht es Entwicklern, digitale Logikdesigns kostengünstig und mit geringen Einstiegshürden in echtes Silizium gießen zu lassen. Ein integraler Bestandteil dieses Ökosystems ist die webbasierte Entwicklungsumgebung "VGA-Playground", die es Anwendern erlaubt, Verilog-Code zur Generierung von VGA-Bildsignalen und zugehörigen Audiosignalen direkt im Browser zu schreiben, zu simulieren und in Echtzeit zu evaluieren. Die physischen Tiny-Tapeout-Demoboards nutzen für die Bildausgabe typischerweise analoge R-2R-Widerstandsnetzwerk-basierte VGA-Pmods (Peripheral Modules) und für den Ton dedizierte PWM-basierte (Pulsweitenmodulation) Audio-Pmods.

Trotz der Eleganz dieser analogen Ausgabemethoden besteht in der Hardware-Design-Community ein immenses Interesse daran, diese Designs auf moderne, volldigitale Schnittstellen zu portieren und auf kostengünstigen FPGA-Entwicklungsboards (Field-Programmable Gate Arrays) zu evaluieren. Ein herausragendes Zielsystem für derartige Portierungen ist der Sipeed Tang Nano 4K. Dieses kompakte und äußerst preiswerte Evaluierungsboard basiert auf der Gowin GW1NSR-LV4C FPGA-Architektur und verfügt über eine integrierte HDMI-Schnittstelle.

Die zentrale ingenieurtechnische Herausforderung dieses Vorhabens besteht in der vollständigen Konvertierung der von den Tiny-Tapeout-Designs emittierten analogen, niederaufgelösten VGA-Steuersignale sowie der 1-Bit-Audiosignale in einen hochfrequenten, digitalen und paketbasierten HDMI-Datenstrom. Diese Untersuchung analysiert die architektonischen Spezifikationen, die signaltheoretischen Grundlagen und evaluiert die verfügbaren Open-Source-Verilog-Ressourcen, um eine vollständige und lauffähige Brücke zwischen der VGA-Playground-Logik und der HDMI-Senke des Tang Nano 4K zu etablieren. Dabei wird ein essenzieller Fokus auf die Integration des Audiokanals gelegt, da die Übertragung von Audiodaten über HDMI tiefgreifende Modifikationen im Bereich der digitalen Signalverarbeitung und der Paketierung in sogenannten "Data Islands" erfordert, was die Komplexität im Vergleich zu einer reinen DVI-Bildübertragung drastisch erhöht.

Architektur und Hardware-Spezifikationen des Tang Nano 4K
Um die Möglichkeiten, aber auch die physikalischen Grenzen der HDMI-Signalerzeugung auf dem Tang Nano 4K zu verstehen, muss zunächst die Hardwarearchitektur des verwendeten FPGAs und der physikalischen Schnittstellen auf Platinenebene detailliert analysiert werden.

Der Gowin GW1NSR-LV4C FPGA
Das Herzstück des Tang Nano 4K ist der Gowin GW1NSR-LV4C FPGA, ein Derivat der LittleBee-Familie. Dieser Chip bietet 4608 Lookup-Tables (LUTs), 3456 Flip-Flops und dedizierte Block-RAM-Ressourcen in Höhe von 180 Kilobit. Zusätzlich integriert der Chip einen harten ARM Cortex-M3 Prozessorkern sowie 8 Megabyte pseudo-statisches RAM (PSRAM), was ihn für hybride Hardware-Software-Designs prädestiniert. Für die reine Synthese eines HDMI-Transmitters sind die logischen Ressourcen des FPGAs absolut ausreichend, da optimierte, quelloffene HDMI-IP-Cores (Intellectual Property) in der Regel weit unter 1000 LUTs beanspruchen.

Besonders relevant für die HDMI-Generierung sind jedoch nicht die Logikgatter, sondern die integrierten Hochgeschwindigkeits-I/O-Blöcke. Die HDMI-Spezifikation basiert auf der Übertragungstechnologie TMDS (Transition-Minimized Differential Signaling). Bei diesem Verfahren werden Videodaten seriell mit einer Frequenz übertragen, die exakt zehnmal so hoch ist wie der zugrunde liegende Pixeltakt. Für eine Standard-VGA-Auflösung von 640 mal 480 Pixeln bei einer Bildwiederholrate von 60 Hertz beträgt der Pixeltakt ungefähr 25,175 Megahertz. Dementsprechend muss der serielle TMDS-Takt bei 251,75 Megahertz liegen.

Die Gowin-Architektur stellt für solche Hochgeschwindigkeitsanwendungen dedizierte Serialisierer-Blöcke namens OSER10 zur Verfügung. Diese Hardware-Primitiven ermöglichen ein effizientes 10:1-Multiplexing der parallelen 10-Bit-Datenströme (die vom TMDS-Encoder generiert werden) in hochfrequente serielle Datenströme, die direkt an die Ausgabepins geleitet werden. Durch die native Nutzung von Double Data Rate (DDR) Registern innerhalb der OSER10-Blöcke kann der interne, synchrone Fast-Clock (FCLK) auf die Hälfte der tatsächlichen TMDS-Rate, also auf circa 125,875 Megahertz, reduziert werden. Diese Halbierung der Taktfrequenz in der Routing-Matrix des FPGAs senkt die Anforderungen an das Timing-Closure drastisch und macht das Design auf FPGAs der Einstiegsklasse überhaupt erst stabil realisierbar.

Die physikalische HDMI-Schnittstelle und elektrische Limitierungen
Eine wesentliche Besonderheit des Tang Nano 4K, die bei der Portierung von Designs zwingend beachtet werden muss, liegt in der elektrischen Beschaltung des HDMI-Ports auf dem Entwicklungsboard. Die I/O-Bänke des verwendeten Gowin-FPGAs unterstützen standardmäßig kein natives TMDS-Current-Mode-Logic (CML), welches für standardkonforme DVI- und HDMI-Verbindungen zwingend spezifiziert ist.

Um dennoch ein Videosignal über den HDMI-Stecker auszugeben, bedient sich das Board eines elektrischen Kunstgriffs: Es nutzt eine AC-Kopplung (Wechselspannungskopplung) in Kombination mit dem LVDS-I/O-Standard (Low-Voltage Differential Signaling) des FPGAs. Die seriellen Datenströme werden über 100-Nanofarad-Kondensatoren in Serie an den HDMI-Port geführt. Diese kapazitive Kopplung führt in der Praxis bei einigen HDMI-Senken (Monitoren oder Fernsehern) zu erheblichen Kompatibilitätsproblemen. Während viele moderne Displays, insbesondere Computermonitore, das AC-gekoppelte LVDS-Signal tolerieren und intern korrekt als TMDS-Signal interpretieren, verweigern andere Geräte (häufig ältere Fernsehgeräte) die Synchronisation komplett.

Ein weiteres, gut dokumentiertes Problem in der Peripheriebeschaltung betrifft die DDC-Leitungen (Display Data Channel), die über den I2C-Bus für das Auslesen der EDID (Extended Display Identification Data) sowie für HDCP-Handshakes zuständig sind. Bei bestimmten Chargen der Tang Nano Serie (insbesondere auch beim Schwestermodell Tang Nano 9K) fehlen die notwendigen Pull-Up-Widerstände auf der 5-Volt-Leitung, wodurch einige Monitore die Existenz einer gültigen Signalquelle auf physikalischer Ebene nicht erkennen. Für eine zuverlässige Funktion des selbst synthetisierten HDMI-Cores ist es daher essenziell, dass sich der Entwickler dieser Limitierungen der physikalischen Schicht bewusst ist, da ein fehlerhaftes Bild nicht zwingend auf fehlerhaften Verilog-Code, sondern auf elektrische Inkompatibilitäten zurückzuführen sein kann.

Analyse der Tiny-Tapeout-Signale und des VGA-Playgrounds
Der "VGA-Playground" hat sich als primäre Entwicklungsumgebung für grafikbasierte Tiny-Tapeout-Projekte etabliert. Um den dort generierten Verilog-Code in ein HDMI-kompatibles Format zu überführen, muss die Struktur der verwendeten Module, das exakte Timing sowie die Pin-Belegung detailliert aufgeschlüsselt werden.

Der hvsync_generator und das Video-Timing
Nahezu alle Projekte im VGA-Playground, von einfachen Streifenmustern ("Stripes") bis hin zu komplexen zellulären Automaten ("Conway"), basieren auf dem fundamentalen Basismodul hvsync_generator.v. Dieses Modul fungiert als zentraler Timing-Controller der gesamten Schaltung und ist exklusiv für die Generierung der vorschriftsmäßigen VGA-Synchronisationsimpulse zuständig. Es liefert folgende primäre Schnittstellensignale an das Benutzerdesign:

hsync (Horizontal Synchronization): Ein periodischer Impuls, der dem Monitor das Ende einer Bildschirmzeile und den Rücklauf des Elektronenstrahls signalisiert.

vsync (Vertical Synchronization): Ein Impuls, der das Ende eines vollständigen Frames (Bildes) markiert und den vertikalen Rücklauf initiiert.

display_on (häufig auch als vde - Video Data Enable bezeichnet): Ein boolesches Signal, das anzeigt, ob sich die Koordinaten aktuell im aktiven, sichtbaren Bereich des Bildschirms befinden. Außerhalb dieses Bereichs (während Front Porch, Sync Pulse und Back Porch) muss dieses Signal zwingend logisch null sein.

hpos und vpos: Zehn- oder zwölfstufige Vektoren, die die exakte X- und Y-Koordinate des aktuell zu berechnenden Pixels repräsentieren. Das Benutzerdesign nutzt diese Koordinaten, um kombinatorisch oder sequenziell die Pixelfarbe zu bestimmen.

Die Auflösung der überwältigenden Mehrheit der Tiny-Tapeout-Demos ist durch den hvsync_generator.v fest auf den VGA-Standard von 640 mal 480 Pixeln bei 60 Hertz fixiert. Es existieren jedoch hochspezialisierte Ausnahmen. So verwenden beispielsweise das "VGA Donut"-Projekt und die "Nyan Cat"-Demo einen stark modifizierten Timing-Controller mit einer unkonventionellen Auflösung von 1220 mal 480 Pixeln bei einem Pixeltakt von 48 Megahertz. Diese Modifikation wurde vorgenommen, um rechenintensive Raymarching-Algorithmen (Sphere Tracing) über einen iterativen CORDIC-Block innerhalb der extremen Limitierungen der Logikgatter zu realisieren. Solche nicht-standardisierten Timings stellen bei der HDMI-Wandlung auf dem Tang Nano 4K eine signifikante Hürde dar. Die TMDS-PLLs des Gowin-FPGAs müssen für derartige Auflösungen extrem präzise konfiguriert werden, um den Faktor 10 für den seriellen Takt (in diesem Fall 480 Megahertz) aufrechtzuerhalten, was nahe an die physikalische Grenze der I/O-Blöcke des GW1NSR-LV4C heranreicht.

Um die Timings des VGA-Standards besser zu verstehen, bietet sich eine tabellarische Darstellung der Pixel-Zyklen an, die für die HDMI-Wandlung exakt repliziert werden müssen:

Timing-Parameter	Horizontal (in Pixel-Zyklen)	Vertikal (in Zeilen)
Aktiver Bereich (Active Video)	640	480
Front Porch	16	10
Sync Pulse	96	2
Back Porch	48	33
Gesamte Periode (Total)	800	525
Polarität der Synchronisation	Negativ (Low-Aktiv)	Negativ (Low-Aktiv)
Diese Timings erfordern zwingend einen Pixeltakt von 25,175 MHz, um eine exakte Bildwiederholrate von 59,94 Hz zu erreichen.

Farbtiefe, Pinout und Padding
Während der analoge VGA-Standard theoretisch eine unendliche Farbtiefe durch stufenlose analoge Spannungspegel zwischen 0 Volt und 0,7 Volt zulässt , sind Tiny-Tapeout-Chips aufgrund ihrer extrem begrenzten I/O-Pins physisch drastisch limitiert. Die standardisierte Pin-Belegung für Tiny-Tapeout-Projekte spezifiziert typischerweise 8 Eingabepins (ui_in), 8 Ausgabepins (uo_out) und 8 bidirektionale Pins (uio_out).

Die meisten VGA-Demos im VGA-Playground nutzen aufgrund dieser Begrenzung lediglich zwei Bit pro Farbkanal (Rot, Grün, Blau), was zu einer Farbpalette von maximal 64 möglichen Farben (R2G2B2) führt. Einige fortgeschrittenere Pmods nutzen 3 Bit pro Kanal, bleiben aber weit unter heutigen Standards.

HDMI hingegen erzwingt im Basisprofil (Baseline) eine Farbtiefe von 24 Bit (8 Bit pro Farbkanal, bekannt als RGB888 oder True Color). Um das schmale 2-Bit-Signal (R[1:0], G[1:0], B[1:0]) der VGA-Playground-Logik HDMI-konform zu formatieren, muss in der Wrapper-Logik auf dem Tang Nano 4K ein dediziertes Color-Mapping durchgeführt werden. Dies geschieht auf Hardwareebene am effizientesten durch Bit-Replikation (Padding), um den gesamten dynamischen Bereich der 8-Bit-Domäne vollständig auszunutzen, ohne komplexe Multiplikatoren zu bemühen. Ein 2-Bit-Eingangswert von 2'b11 (maximale Helligkeit) wird durch einfache Signal-Konkatenation zu 8'b11111111 (Dezimal 255) erweitert. Die entsprechende Verilog-Zuweisung lautet: assign video_r_8bit = {tt_r_2bit, tt_r_2bit, tt_r_2bit, tt_r_2bit};.

Die Audio-Infrastruktur im Tiny Tapeout
Ein weiterer essenzieller Aspekt der Integration ist der Audiokanal, der eine erhebliche Komplexitätssteigerung mit sich bringt. Die Spezifikationen für die Audio-Ausgabe im Tiny-Tapeout-Ökosystem (insbesondere über den dedizierten TT Audio Pmod) definieren zumeist einen einzelnen Pin (z.B. uio_out oder uo_out), über den ein eindimensionaler, hochfrequenter Bitstream gesendet wird. Bei Stereo-Anwendungen kommen zwei Pins (uio_out und uio_out) zum Einsatz.

Dieses Signal liegt in der Regel als Pulsweitenmodulation (PWM) oder Pulsdichtemodulation (PDM, oft realisiert als Sigma-Delta-Modulation erster Ordnung) vor. In der rein analogen Welt reicht ein einfacher passiver RC-Tiefpassfilter auf dem Pmod-Board aus, um diese hochfrequenten Rechtecksignale zu integrieren und in eine hörbare analoge Audio-Wellenform zu glätten, die dann an Kopfhörer oder Verstärker weitergegeben wird.

In der rein digitalen Domäne der HDMI-Übertragung ist dieses analoge Konzept jedoch nutzlos. HDMI überträgt Audiosignale zwingend digital als lineares Pulse-Code-Modulation-Signal (L-PCM) in Form von diskreten, mehrbittigen Abtastwerten (beispielsweise als 16-Bit Integer-Werte bei einer Abtastrate von 48 kHz). Die Konvertierung des 1-Bit-Audio-Bitstreams des VGA-Playgrounds in einen HDMI-konformen L-PCM-Datenstrom erfordert daher zwingend signifikante digitale Signalverarbeitung (Digital Signal Processing, DSP) in Echtzeit innerhalb des FPGAs.

Theoretische Grundlagen der HDMI- und Audio-Synthese
Die Überführung der isolierten VGA-Logik und der 1-Bit-Audio-Logik in einen vollumfänglich standardkonformen HDMI-Datenstrom erfordert das tiefe Verständnis dreier völlig separater technologischer Domänen: Das TMDS-Encoding für die Bilddaten, die Generierung sogenannter "Data Islands" für Zusatzdaten und Audio, sowie die DSP-basierte Audio-Dezimation zur Signalkonvertierung.

TMDS-Encoding für Videodaten
Die Transition-Minimized Differential Signaling (TMDS) Schicht überträgt Daten über vier differenzielle Leitungspaare: Drei Kanäle für die Farben (Kanal 0: Blau und Sync, Kanal 1: Grün, Kanal 2: Rot) und einen Kanal für den synchronen Pixeltakt. Während der aktiven Videoübertragung (immer dann, wenn das Signal display_on den Wert 1 annimmt), kodiert der TMDS-Encoder die parallelen 8-Bit-Pixelwerte in serielle 10-Bit-Wörter.

Dieser komplexe 8b/10b-Algorithmus erfüllt zwei essenzielle Aufgaben auf der physikalischen Schicht:

Minimierung von Übergängen (Transition Minimization): Durch kaskadierte XOR- oder XNOR-Verknüpfungen der aufeinanderfolgenden Bits werden schnelle Pegelwechsel (von 0 auf 1 und vice versa) im Signalstrom minimiert. Dies reduziert elektromagnetische Interferenzen (EMI) signifikant und verbessert die Signalintegrität bei den geforderten Frequenzen im Gigahertzbereich.

Gleichstromfreiheit (DC Balancing): Ein fortlaufender Disparitäts-Zähler (Disparity Counter) überwacht in Echtzeit das Verhältnis von übertragenen Nullen und Einsen im Datenstrom. Falls ein signifikantes Ungleichgewicht auftritt, invertiert der Encoder das gesamte 10-Bit-Wort und signalisiert dies über ein spezielles Flag-Bit. Dieser Vorgang verhindert eine DC-Drift auf den AC-gekoppelten Leitungen und garantiert eine konstante mittlere Signalspannung.

HDMI Data Islands und TERC4-Encoding
Der fundamentale technologische Unterschied zwischen einem veralteten DVI-Signal (Digital Visual Interface) und einem vollwertigen HDMI-Signal liegt in der Ausnutzung der Bild-Austastlücken (Blanking Intervals). Während des horizontalen und vertikalen Blankings, also in den Phasen, in denen keine sichtbaren Videopixel an das Display gesendet werden, überträgt DVI lediglich die Synchronisationssignale HSYNC und VSYNC. HDMI hingegen nutzt exakt diese Zeitfenster, um digitale Zusatzdaten, sogenannte "Data Islands" (Dateninseln), an das Empfangsgerät zu senden.

In diesen Data Islands werden die unkomprimierten Audiodaten (L-PCM) sowie verschiedene InfoFrames (wie Auxiliary Video Information oder Audio InfoFrames) übertragen. Diese InfoFrames teilen dem angeschlossenen Monitor oder Fernseher mit, um welches exakte Video- und Audioformat es sich handelt, damit dieser seinen Decoder korrekt konfigurieren kann.

Um diese kritischen Zusatzdaten zuverlässig von den reinen Videodaten unterscheiden zu können, verwendet HDMI während der Data Islands ein vollkommen anderes Kodierungsverfahren namens TERC4 (TMDS Error Reduction Coding). TERC4 wandelt 4 Bit an Eingangsdaten deterministisch über eine feste Lookup-Tabelle in 10-Bit-Wörter um, die eine extrem hohe Fehlerresistenz aufweisen. Der Algorithmus muss strikt den vorgegebenen Zustandsautomaten der HDMI-Spezifikation (Version 1.3a oder 1.4b) befolgen. Dies inkludiert das Senden von speziellen Präambeln und sogenannten Guard-Bands (Schutzbändern), die dem HDMI-Receiver eindeutig den Start und das Ende einer Data Island signalisieren. Ohne dieses exakte Framing verwirft der Empfänger die Audiodaten als Leitungsrauschen.

Digitales Filtern: Vom 1-Bit PWM/PDM zum L-PCM Format
Wie im vorherigen Abschnitt erläutert, bedarf es einer Signalkonvertierung, um das 1-Bit-Audiosignal der Tiny-Tapeout-Designs für die Data Islands nutzbar zu machen. Ein PWM- oder PDM-Signal ist definitionsgemäß ein stark überabgetastetes Signal (Oversampling). Um daraus einen validen 16-Bit-PCM-Wert bei der Ziel-Abtastrate von 48 kHz zu extrahieren, muss das Signal im FPGA tiefpassgefiltert und anschließend dezimiert (heruntergetaktet) werden.

In der Architektur von FPGA-Hardware wird hierfür typischerweise ein sogenannter CIC-Filter (Cascaded Integrator-Comb) oder, in ressourcenschonenden Szenarien, ein einfacher Gleitender Mittelwertfilter (Moving Average Filter) in Verilog implementiert. Der Filter summiert die Nullen und Einsen des hochfrequenten Bitstreams kontinuierlich über ein definiertes Zeitfenster auf (Integration) und generiert so ein diskretes Multibit-Wort, das die analoge Spannungsamplitude zu einem exakten Zeitpunkt repräsentiert.

Die mathematische Reduktion veranschaulicht diesen Prozess: Bei einem Pixeltakt von 25,175 MHz und einer geforderten PCM-Abtastrate von 48 kHz summiert der Filter rund 524 Samples auf (25.175.000 Hz / 48.000 Hz = 524,4). Die aggregierte Anzahl der logischen Einsen in diesem spezifischen Fenster wird durch Skalierung in einen standardkonformen 16-Bit-L-PCM-Wert übersetzt. Dieser zeitlich synchronisierte 16-Bit-Wert wird anschließend in FIFO-Puffern (First-In, First-Out) abgelegt, bis die nächste Austastlücke auftritt und der HDMI-Core die Daten als Data Island versenden kann.

Evaluation bestehender Open-Source-Verilog-Ressourcen
Die Open-Source-Hardware-Community hat in den vergangenen Jahren erhebliche Fortschritte bei der Entwicklung lizenzfreier, performanter HDMI-Transmitter für FPGAs gemacht. Eine tiefgehende Analyse der öffentlich verfügbaren GitHub-Repositories, die für die Architektur des Tang Nano 4K adaptiert werden können, offenbart ein breites Spektrum an Lösungen mit stark variierenden Reifegraden, Programmiersprachen und Feature-Sets.

Die folgende Evaluation beleuchtet die vielversprechendsten Kandidaten für die anstehende Integrationsaufgabe.

Das Projekt hdl-util/hdmi
Das Repository hdl-util/hdmi stellt unbestreitbar den absoluten Goldstandard für dieses spezifische Unterfangen dar. Es handelt sich um eine hochgradig modulare, in SystemVerilog geschriebene und vollständig quelloffene Implementierung eines HDMI-1.4b-Transmitters.

Relevanz für das Projekt:

Vollständige Audio-Unterstützung: Im eklatanten Gegensatz zu fast allen anderen freien IP-Cores unterstützt hdl-util/hdmi die Generierung nativer HDMI Data Island Packets in vollem Umfang. Der Code generiert vollautomatisch L-PCM-Audio-Pakete, Audio-InfoFrames und vor allem die kritischen Audio Clock Regeneration (ACR) Pakete. Letztere sind für die Synchronisation des Audios auf dem Zielmonitor essenziell, da sie dem Empfänger das Taktverhältnis zwischen Video und Audio übermitteln.

Gowin-Kompatibilität: Das Projekt wird vom Autor aktiv für die Gowin-Architektur, spezifisch den Tang Nano 9K, getestet. Da der Tang Nano 9K (GW1NR-9) und der Tang Nano 4K (GW1NSR-LV4C) beide die identische Gowin EDA-Software nutzen und über sehr ähnliche Architekturen (wie die OSER10-Serialisierer-Blöcke) verfügen, ist eine Portierung auf den 4K mit minimalen Anpassungen der physikalischen Constraints-Datei und der PLL-Generatoren (clk_wiz) zügig machbar.

Architektonische Struktur: Der SystemVerilog-Code kapselt die hochkomplexe TERC4-Kodierung sowie das fehlerkorrigierende BCH-Error-Correction-Coding (Bose-Chaudhuri-Hocquenghem) in klar getrennten Modulen, was die Einbindung in bestehende Verilog-Designs enorm erleichtert.

Eine Herausforderung bei diesem Repository besteht in der verwendeten Hardwarebeschreibungssprache. SystemVerilog wird von älteren oder stark abgespeckten Open-Source-Synthesewerkzeugen (wie Yosys in bestimmten Konfigurationen) oft nur teilweise unterstützt. Die offizielle, proprietäre Gowin-EDA kann SystemVerilog-2017-Code jedoch standardmäßig und fehlerfrei verarbeiten.

Das Projekt verilog-indeed/nano4k_hdmi_tx
Dieses Repository wurde hochspezifisch und exklusiv für den Tang Nano 4K und seinen verbauten GW1NSR-Core geschrieben. Es bietet eine saubere, extrem gut dokumentierte RTL-Implementierung in reinem Verilog, wodurch Kompatibilitätsprobleme mit Synthesetools ausgeschlossen sind.

Relevanz für das Projekt:

Native 4K-Optimierung: Das Projekt instanziiert die hardwarenahen Gowin-Primitiven, insbesondere die OSER10-Serialisierer, exakt so, wie es für den Tang Nano 4K auf Register-Ebene erforderlich ist. Es bietet zudem Wrapper-Module für Testbilder und SRAM-Framebuffer-Zugriffe.

Stabilität und Performance: Durch die direkte, händisch optimierte Nutzung der DDR-Ressourcen des Gowin-FPGAs ist das Design extrem timing-stabil bei der Standard-Auflösung von 720x480 bei 60 Hertz.

Der entscheidende Nachteil dieses Projekts im Kontext der vorliegenden Anforderung: Der Transmitter überträgt derzeit ein reines, nur aufwärtskompatibles DVI-Signal. Die komplexe Logik für Data Islands, TERC4-Encoding, Fehlerkorrektur und Audio-Paketierung fehlt vollends. Ein Nachrüsten dieser Funktionen käme einer kompletten Neuentwicklung gleich.

Weitere nennenswerte Implementierungen
Neben den beiden Hauptkandidaten existieren weitere Projekte, deren Architekturen wertvolle Referenzen darstellen:

splinedrive/my_hdmi_device: Hierbei handelt es sich um eine plattformübergreifende DVI/HDMI-Implementierung, die für iCE40, ECP5 und explizit auch für den Tang Nano 4K geschrieben wurde. Der Code glänzt durch die Unterstützung von Single-Data-Rate (SDR) und Double-Data-Rate (DDR) Transfers. Allerdings wird der Punkt "HDMI Audio (Island Mode)" in der öffentlichen Roadmap des Entwicklers explizit als "TODO" geführt, weshalb der Core für das vorliegende Problem mit Audio-Anforderung noch unvollständig ist.

WangXuan95/FPGA-HDMI: Dieses Repository bietet ebenfalls eine überaus solide DVI-Lösung mit direktem Support und Constraint-Files für das Tang Nano 4K Board. Der modulare Ansatz der Implementierung erlaubt die einfache, getaktete Einspeisung von resp_red, resp_green und resp_blue Pixeln im Raster-Verfahren. Wie bei den vorherigen Alternativen beschränkt sich die Funktionalität jedoch primär auf Bilddaten ohne jegliche Audio-Integration.

juj/HDMI_testikuva: Ein extrem minimalistisches Design für den Tang Nano 4K, das lediglich ein statisches 640x480 Testbild (das finnische "Testikuva") generiert und ausgibt. Das Projekt ist exzellent als pädagogisches Werkzeug geeignet, um die absolute Basis der Gowin OSER10-Instanziierung zu erlernen, jedoch mangelt es auch hier an jeglicher Audio- und InfoFrame-Unterstützung.

sipeed/TangNano-4K-example: Die offiziellen Beispiele des Board-Herstellers Sipeed (wie hdmi_720p oder camera_hdmi) bieten zwar funktionsfähigen Code, basieren jedoch meist auf verschleierten oder extrem rudimentären IP-Cores, die sich schwer modifizieren oder um Audio-Funktionen erweitern lassen.

Um die Vor- und Nachteile der wichtigsten Repositories für den Tang Nano 4K übersichtlich darzustellen, dient die folgende tabellarische Gegenüberstellung:

Repository	Sprache	Audio-Support (Data Islands)	TMDS & Hardware-Serialisierung	Fokus-Hardware
hdl-util/hdmi	SystemVerilog	Ja (L-PCM, InfoFrames, ACR)	Integriert, adaptierbar für Gowin	Generisch (Gowin Tang Nano 9K getestet)
nano4k_hdmi_tx	Verilog	Nein (Nur DVI)	Nativ via Gowin OSER10	Exklusiv Tang Nano 4K
my_hdmi_device	Verilog / C	Nein (Geplant / TODO)	SDR und DDR TMDS Encoder	Multi-Plattform (inkl. Tang Nano 4K)
FPGA-HDMI	Verilog	Nein (Nur DVI)	Eigenentwicklung TMDS	Generisch (Tang Nano 4K Constraint vorhanden)
HDMI_testikuva	Verilog	Nein (Nur DVI Testbild)	Minimalistischer TMDS Encoder	Exklusiv Tang Nano 4K
Integrationskonzept: Vom VGA-Playground zu HDMI mit Audio
Um die primäre Zielstellung zu erfüllen – die lauffähige Ausführung von VGA-Playground-Code inklusive einer intakten Audioausgabe auf einem Tang Nano 4K mittels der HDMI-Schnittstelle –, ist ein hybrider architektonischer Ansatz die effizienteste und robusteste Ingenieursentscheidung. Kein einzelnes Repository liefert eine schlüsselfertige Lösung. Das Gesamtsystem muss daher aus einer präzisen Orchestrierung verschiedener IP-Komponenten bestehen.

Hierbei stellt das hdl-util/hdmi-Repository die hochkomplexe Protokoll-Ebene (Data Islands, Audio) zur Verfügung, während die physikalische I/O-Ebene (die Serialisierung auf die Pins) durch Code-Bausteine aus nano4k_hdmi_tx oder direkt aus den Gowin-Dokumentationen adaptiert wird. Der folgende Blueprint beschreibt die tiefgehende schrittweise Integration auf Register-Transfer-Ebene (RTL).

Schritt 1: Taktgenerierung (Clock Domain Management)
Ein FPGA-System für HDMI erfordert eine absolut strikte und jitterarme Kontrolle über verschiedene Taktdomänen. Der Tang Nano 4K besitzt einen On-Board-Quarzoszillator mit einer Frequenz von 27 Megahertz. Eine Phase-Locked Loop (PLL) – typischerweise instanziiert über den Gowin EDA IP Core Generator (oft als clk_wiz oder rPLL bezeichnet) – muss zwei phasenstarr gekoppelte Takte (kohärent) generieren:

Pixel-Clock (pclk): Für eine Standardauflösung von 640x480 bei 60 Hertz muss dieser Takt exakt 25,175 MHz betragen.

Serial-Clock (pclk_x5): Dieser Takt bedient die Serialisierer. Da der OSER10-Block der Gowin-Architektur Double Data Rate (DDR) nativ unterstützt, muss der serielle Takt nur exakt die Hälfte des tatsächlichen TMDS-Bit-Takts (welcher 251,75 MHz beträgt) aufweisen. Somit ist ein Takt von 125,875 MHz zu konfigurieren.

Sollte das Tiny-Tapeout-Design stark abweichende Auflösungen verwenden (wie die 48 MHz für die 1220x480 Auflösung des VGA Donut Projekts), müssen beide PLL-Parameter entsprechend skaliert werden (48 MHz für pclk, 240 MHz für pclk_x5), was eine signifikante thermische und timing-technische Herausforderung für das Silizium darstellt.

Schritt 2: Integration des VGA-Playground Cores
Das im Browser des VGA-Playgrounds erstellte Top-Modul des Tiny-Tapeout-Designs (meist project.v) sowie dessen Abhängigkeit hvsync_generator.v werden unverändert in das Gowin-FPGA-Projekt importiert. Der zuvor generierte pclk (25,175 MHz) speist den Takteingang des hvsync_generator. Die Ausgänge des Tapeout-Moduls sind die 2-Bit (oder bei einigen Pmods 3-Bit) RGB-Signale, hsync, vsync und das 1-Bit-Audiosignal auf dem konfigurierten Pmod-Pin (z.B. uo_out).

Schritt 3: Signalaufbereitung und Color-Mapping (Padding)
Die aus dem Tiny-Tapeout-Core extrahierten Signale müssen für die breitere HDMI-Schnittstelle aufbereitet werden. Da der hdl-util/hdmi-Core einen 24-Bit-RGB-Vektor (8 Bit pro Farbe) erwartet, müssen die 2-Bit-Farbdaten durch logische Bit-Vervielfältigung hochskaliert werden. Dies geschieht durch einfache Zuweisungen im Top-Modul des Wrappers:

assign video_r_8bit = {tt_r_2bit, tt_r_2bit, tt_r_2bit, tt_r_2bit};
assign video_g_8bit = {tt_g_2bit, tt_g_2bit, tt_g_2bit, tt_g_2bit};
assign video_b_8bit = {tt_b_2bit, tt_b_2bit, tt_b_2bit, tt_b_2bit};

Das zwingend benötigte Signal display_on (oder Video Data Enable) wird direkt aus der kombinatorischen Logik des hvsync_generator abgeleitet und unmodifiziert an den HDMI-Core weitergereicht.

Schritt 4: Audio-Dezimation (Digitales Filter für L-PCM)
Das hochfrequente 1-Bit-Signal (z.B. uio_out) des Tiny-Tapeout-Moduls erfordert zwingend eine digitale Signalverarbeitung, bevor es in den HDMI-Core gespeist werden kann. Es kann nicht direkt übertragen werden. Ein dediziertes Verilog-Modul muss geschrieben werden, das als Filter agiert.

Der Filter taktet das 1-Bit-Signal mit einer extrem hohen Frequenz ab (bequemerweise kann hierfür ebenfalls der 25,175 MHz Pixel-Clock oder ein separater High-Speed-Clock verwendet werden). Ein Zählerbaustein integriert (summiert) die Werte über ein Zeitfenster, das exakt der gewünschten HDMI-Audio-Abtastrate entspricht (in der Regel 48 kHz). Nach Ablauf des Zählers (z.B. nach 524 Takten bei 25 MHz zu 48 kHz) wird die angesammelte Summe in ein 16-Bit-L-PCM-Wort skaliert und in ein Ausgangsregister geschrieben. Gleichzeitig wird der Summierer für den nächsten Zyklus auf null zurückgesetzt. Dieser kontinuierlich aktualisierte 16-Bit-Wert wird dem HDMI-Core als Audio-Sample übergeben.

Schritt 5: HDMI-Paketierung mit dem hdl-util/hdmi Core
Der hochkomplexe SystemVerilog-Code aus dem hdl-util/hdmi Projekt (spezifisch das Modul hdmi.sv) wird als zentrale Protokollschicht instanziiert. Er nimmt folgende Eingangssignale auf:

clk_pixel (25,175 MHz)

clk_audio (Optional, falls ein echt asynchroner Audiotakt verwendet wird. Andernfalls verlässt sich das Modul auf die Audio Clock Regeneration (ACR) Parameter)

rgb_24bit (Der aufskalierte Videodatenstrom)

hsync, vsync, vde (Die Timing-Signale)

audio_sample_word (Der gefilterte 16-Bit L-PCM Wert aus Schritt 4)

Der hdmi.sv-Core übernimmt nun die gesamte schwere Hebearbeit: Er fügt Preambles ein, codiert die Videodaten mit dem 8b/10b-Verfahren zur Gleichstromfreiheit, und verpackt die L-PCM-Audiodaten sowie die notwendigen Audio InfoFrames mittels des TERC4-Verfahrens in die Austastlücken. Das resultierende Ausgangssignal des Cores besteht aus drei 10-Bit TMDS-Datenwörtern (für die drei Farbkanäle) und einem 10-Bit TMDS-Taktwort pro Pixeltakt-Zyklus.

Schritt 6: Physikalische I/O über Gowin OSER10-Serialisierer
Die vier 10-Bit-Wörter aus dem HDMI-Protokoll-Core liegen nun parallel vor und müssen in den physischen FPGA-Pins serialisiert werden. Da der Tang Nano 4K keine dedizierten Gigabit-Transceiver wie teurere FPGAs besitzt, wird hierfür zwingend die proprietäre Gowin-Instanziierung genutzt, wie sie in Projekten wie nano4k_hdmi_tx meisterhaft demonstriert wird.

Das Hardware-Primitiv OSER10 wird im Top-Level-Wrapper viermal instanziiert (für Rot, Grün, Blau und den Taktkanal). Es empfängt den langsamen Parallel-Takt (pclk) und den schnellen Seriell-Takt (pclk_x5). Die bitserielle Ausgabe des OSER10-Blocks wird direkt mit dem Ausgangstreiber-Primitiv ELVDS_OBUF (oder alternativ TLVDS_OBUF) verbunden. Dieses Primitiv wandelt das Single-Ended-Signal aus der Logik in die differenziellen Signalepaare (TMDS_P, TMDS_N), die über die Routing-Matrix direkt mit den physikalischen Pins des HDMI-Ports auf dem Tang Nano 4K verbunden sind.

Limitationen und Hardware-Herausforderungen
Selbst bei methodisch fehlerfreier Implementierung des oben beschriebenen Verilog-Integrationskonzepts bleiben auf dem Tang Nano 4K inhärente Herausforderungen bestehen, die in der physikalischen Natur des FPGAs und der Auslegung der Peripheriebauteile begründet liegen.

Die TMDS/LVDS Spannungs-Dissonanz
Wie bereits in der Architekturanalyse thematisiert, gibt das Gowin FPGA die Signale aus Kostengründen als AC-gekoppeltes LVDS mit 3,3 Volt Toleranz aus und nicht als reines Current-Mode Logic (CML) TMDS. Der HDMI-Standard ist bei CML-Pegeln strikt. Entwickler müssen sich der Realität bewusst sein, dass ältere Monitore oder sehr strikt konzipierte HDMI-Senken das Signal möglicherweise komplett ablehnen – der Bildschirm bleibt schwarz –, selbst wenn das digitale Timing, die TERC4 Data Islands und die Verilog-Synthese absolut fehlerfrei sind. Abhilfe schafft hier oft nur das Testen mit verschiedenen modernen Monitormodellen oder der ungern gesehene Einsatz von zwischengeschalteten, externen aktiven HDMI-Repeatern/Level-Shiftern zur Signalregeneration.

Audio Clock Regeneration (ACR) und Takt-Jitter
Die HDMI-Spezifikation erfordert, dass der Empfänger (Monitor/Fernseher) den Audiotakt aus dem Pixeltakt präzise rekonstruieren kann. Dies geschieht über die bereits erwähnten ACR-Pakete in den Data Islands, die die Parameter N (ein konstanter Multiplikator) und CTS (Cycle Time Stamp) übertragen. Diese Werte definieren das präzise mathematische Verhältnis zwischen dem Pixeltakt und dem Audiotakt. Wenn das Tiny-Tapeout-Design einen nicht-standardisierten Pixeltakt verwendet oder der Oszillator des Tang Nano 4K starkem thermischen Drift unterliegt, müssen N und CTS im hdl-util/hdmi-Core hochpräzise manuell neu berechnet und als Parameter gesetzt werden. Ist die ACR-Konfiguration fehlerhaft, schaltet der Monitor den Audio-Datenstrom stumm oder gibt ihn mit extrem störenden, hörbaren Knack-Aussetzern (Dropouts) wieder.

Timing Closure und Routing-Verzögerungen
Obwohl der Gowin GW1NSR-LV4C über hochoptimierte dedizierte OSER10-Blöcke an den I/O-Bänken verfügt, kann das Routing von komplexer Logik innerhalb der FPGA-Fabric zu massiven Problemen beim Timing Closure führen. Insbesondere dann, wenn große Teile des Tiny-Tapeout-Designs (das bis zu 4000 oder 8000 Gates beanspruchen kann) mit dem ressourcenhungrigen hdl-util/hdmi-Core und dem notwendigen DSP-Audiofilter in einem einzigen Projekt kombiniert werden, stößt der P&R-Algorithmus (Place and Route) an seine Grenzen. Der Synthesetoolchain (egal ob der offiziellen Gowin EDA oder Open-Source-Alternativen wie Yosys in Verbindung mit NextPNR) fällt es mit zunehmender Füllung der Logikressourcen schwer, die extrem engen Timing-Vorgaben für den 125 Megahertz DDR-Takt der Serialisierer einzuhalten, da lange kombinatorische Pfade quer über den Chip entstehen. Zur Wahrung der Stabilität ist extensives Pipelining – das strategische Einfügen von Register-Stufen zum Aufbrechen langer logischer Pfade – zwischen dem VGA-Generator, dem Audio-Filter und dem HDMI-Core zwingend erforderlich.

Fazit
Die vorliegende Evaluierung hat fundiert belegt, dass die Portierung von Tiny-Tapeout-Designs – inklusive der im VGA-Playground generierten Verilog-Strukturen – auf den HDMI-Ausgang des Tang Nano 4K unter Einbeziehung des Audiokanals technisch vollständig realisierbar ist. Die Open-Source-Community stellt alle grundlegenden intellektuellen Bausteine zur Verfügung, um diese komplexe Wandlung von analogen Steuersignalen hin zu paketierten digitalen Hochgeschwindigkeitsdatenströmen vorzunehmen. Es existiert jedoch noch kein singuläres, monolithisches Repository, das als reine "Plug-and-Play"-Lösung alle Facetten nahtlos vereint.

Die optimale und stabilste Systemarchitektur erfordert die gezielte Verschmelzung von drei separaten Domänen in einem Custom-Wrapper:

Der Tiny-Tapeout-Logik (basierend auf hvsync_generator.v), die das fundamentale VGA-Timing und die rohen Bild-/Tondaten liefert.

Dem hdl-util/hdmi-Repository, das die hochkomplexe Protokollschicht für HDMI Data Islands, L-PCM Audio und TERC4-Encoding als robuste SystemVerilog-Komponente meistert.

Der Gowin-spezifischen Hardware-Abstraktion, entlehnt aus Projekten wie nano4k_hdmi_tx, um die OSER10-Serialisierer und ELVDS_OBUF-Treiber timingsicher an die physikalischen HDMI-Pins zu binden.

Die größte ingenieurtechnische Eigenleistung für den Entwickler liegt dabei in der Implementierung des erforderlichen Dezimationsfilters, der das 1-Bit-PWM/PDM-Signal der Tiny-Tapeout-Audio-Spezifikation sauber in einen HDMI-konformen 16-Bit-PCM-Strom wandelt.

Zusammenfassend lässt sich konstatieren, dass der Tang Nano 4K in Kombination mit modernen Open-Source-Verilog-Ressourcen eine überaus potente, wenn auch elektrisch stellenweise kompromissbehaftete Entwicklungsplattform darstellt. Entwickler, die bereit sind, die architektonische Lücke zwischen analog-gedachten Pmod-Ausgaben und digitaler TERC4/TMDS-Paket-Infrastruktur durch entsprechende DSP-Modifikationen und die korrekte Instanziierung von Serialisierer-Primitiven zu schließen, erhalten eine hocheffiziente, ASIC-verifizierbare Simulationsumgebung, die eine vollständige Bild- und Tonausgabe über ein handelsübliches HDMI-Kabel ermöglicht.
