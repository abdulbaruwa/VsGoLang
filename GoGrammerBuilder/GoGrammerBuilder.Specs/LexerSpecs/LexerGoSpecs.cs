using System.IO;
using System.Reflection;
using Antlr4.Runtime;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace GoGrammerBuilder.Specs.LexerSpecs
{
    [TestClass]
    public class LexerGoSpecs
    {
        [TestMethod]
        public void CanTokenizeSource()
        {
            var locale = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location) + @"\lexerSpecs\basicTypes.go";
            var goSource = File.ReadAllText(locale);
            var goSourceStream = new StringReader(goSource);

            //Create lexer
            var lexer = new LexerGo(new AntlrInputStream(goSourceStream));
            var tokenStream = new CommonTokenStream(lexer);

            var toks = tokenStream.GetTokens();
            tokenStream.Fill();

            Assert.IsTrue(toks.Count > 0);
        }
    }
}
