
test:
	vusted --shuffle -v
.PHONY: test

doc:
	rm -f ./doc/curstr.nvim.txt
	nvim --headless -i NONE -n +"lua dofile('./spec/lua/curstr/doc.lua')" +"quitall!"
	cat ./doc/curstr.nvim.txt
.PHONY: doc
