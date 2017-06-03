var PDFDocument = require('pdfkit');

module.exports = function(req, res){
  console.log(req.query)

  var token = req.query.token;
  var symbol = req.query.symbol;
  var author = req.query.author;
  var email = req.query.email;
  var address = req.query.address;

  var protocols = JSON.parse(req.query.protocols);
  protocols = Object.keys(protocols).filter(function(p) { return protocols[p]; })
  var title = getTitle(protocols)
  var subtitle = "";

  if (author !== "") subtitle = author + "\n";
  if (email !== "") subtitle = subtitle + email + "\n";
  
  var whitepaper = getWhitepaper(protocols);
  

  var doc = new PDFDocument({ title: token, author: author });
  

  // Title page
  doc.font('Times-Bold', 24).text(token + ": ", {align:"center"});
  doc.font('Times-Bold', 18).text(title, {align:"center"});
  doc.moveDown();

  doc.font('Times-Roman', 14).text(subtitle, {align:"center"});
  if (address !== "") {
    address = "https://classicetherwallet.com/#buy-ico?owner=" + address;
    doc.text("Crowdsale Address: ")
        .text(address, {link: address, underline:true, align: "center"});
  }
  doc.moveDown();

  doc.font('Times-Roman', 12);

  var sections = Object.keys(whitepaper);

  for (s in sections) {
    var k = sections[s];
    var content = whitepaper[k];

    if(content.length > 0) {
        doc.moveDown();
        var header = keywordReplace(k, token, symbol);

        doc.font('Times-Bold', 14).text(header);
        doc.font('Times-Roman', 12)


        for(c in content) {
            var para = content[c];
            if (para.img) {
                doc.moveDown();
                doc.image(__dirname + para.img, {width: 450}).moveDown();
            } else if (para.code) {
                doc.moveDown();
                doc.font('Courier', 12).text(keywordReplace(para.code, token, symbol));
                doc.moveDown();
            } else if (k == "References") {
                var num = parseInt(c) + 1;
                doc.font('Times-Roman', 12).text("[" + num + "] " + keywordReplace(para, token, symbol));
            } else {
                doc.font('Times-Roman', 12).text(keywordReplace(para, token, symbol), {indent: 32});
            }
        }
    }
  }

  doc.end();
  res.contentType("application/pdf");
  doc.pipe(res); 

};

function keywordReplace(str, token, symbol) {
    return str.replace(/_PROTOCOL_/g, token).replace(/_COIN_/g, symbol);
}

function getWhitepaper(protocols) {
    var template = require('./papers/template.js');
    var sections = Object.keys(template);

    for (p in protocols) {
        var wp = require('./papers/' + protocols[p] + '.js');
        for (s in sections) {
            if (wp[sections[s]]) {
                template[sections[s]] = template[sections[s]].concat(wp[sections[s]])
            }
        }
    }
    return template;

}

function getTitle(protocols) {
    var title = 'Secure Untrusted Anonymous Decentralised Generalised One-time Ring Signature Peer-to-Peer Scalable Off-Chain Electronic Instant Cash System and MimbleWimble Transaction Ledger Consensus Algorithm';
    var removals = [];

    if (!protocols.includes("bitcoin")) 
        removals = removals.concat(["Peer-to-Peer ", "Electronic ", "Cash ", "System "])
    if (!protocols.includes("ripple"))
        removals = removals.concat(["Consensus ", "Algorithm"]) 
    if (!protocols.includes("ethereum"))
        removals = removals.concat(["Secure ", "Decentralised ", "Generalised ", "Transaction ", "Ledger "]) 
    if (!protocols.includes("cryptonote"))
        removals = removals.concat(["Untraceable ", "One-time Ring Signature "]) 
    if (!protocols.includes("mimblewimble"))
        removals = removals.concat(["MimbleWimble "]) 
    if (!protocols.includes("lightning"))
        removals = removals.concat(["Scalable Off-Chain ", "Instant "]) 
    for (r in removals) {
        title = title.replace(removals[r], "");
    }
    if (title.substr(title.length - 4) == "and ")
        title = title.replace(" and ", "")
    if (title == "")
        title = "This paper contains my complete knowledge of the Blockchain"
    return title
}