# diagon.nvim

Use [Diagon](https://github.com/ArthurSonzogni/Diagon) within neovim 
and retain the instructions so they can be modified.

[![asciicast](https://asciinema.org/a/fU8ga9yFMXVSdECZf7zgO9m16.svg)](https://asciinema.org/a/fU8ga9yFMXVSdECZf7zgO9m16)

## Installation

### Lazy

```
  {
    "mckean/diagon.nvim",
    config = function()
      require("diagon")
    end,
  },
```

### Usage

Currently the following generators are supported

* Sequence Diagram
* Mathematic Expression

Providing a name is optional but encouraged, especially when 
using multiple entries in a single document.

#### Sequence Diagram
````
```sequence name
hello -> world: hi!
world -> peace: jey!
```
````
```
<!-- sequence_output_name
┌─────┐┌─────┐┌─────┐
│hello││world││peace│
└──┬──┘└──┬──┘└──┬──┘
   │      │      │   
   │ hi!  │      │   
   │─────>│      │   
   │      │      │   
   │      │ jey! │   
   │      │─────>│   
┌──┴──┐┌──┴──┐┌──┴──┐
│hello││world││peace│
└─────┘└─────┘└─────┘
-->
```

#### Math Expression

````
```math name
1+1/2 + sum(i,0,10) = 113/2
```
````
```
<!-- math_output_name
        10         
        ___        
    1   ╲       113
1 + ─ + ╱   i = ───
    2   ‾‾‾      2 
         0         
-->
```
