# Quotly'11 (meets CQRS)

Quotly is a social web application to manage collections of quotations. It is a personal sandbox for experimentation. It has been reimplemented several times using different frameworks and libraries. The current production version is available at [http://quot.ly][1].

This incarnation of Quotly implements the CQRS pattern in Ruby, based on the experience of [BankSimplistic][2].

## Previous Versions

* [Quotes'07][3] -- The original one. A simple Rails 2.1 application to learn the language and the framework.
* [Quotes'08][4] -- A failed experiment. The constraint: Don't use any existing framework, be Rack compliant.
* [Quotly'10][5] -- Current version [in production][1]. Sinatra + Mustache + Redis. Tested with Steak.

[1]: http://quot.ly
[2]: http://github.com/cavalle/banksimplistic
[3]: http://github.com/cavalle/quotly/tree/quotes07
[4]: http://github.com/cavalle/quotly/tree/quotes09
[5]: http://github.com/cavalle/quotly/tree/quotly10

