<div align="center">
  <h1 align="center">Cairo Fixed Point Arithmetic</h1>
  <h3 align="center">Uses 123 bit for integer part and 128 for fractional and packs everything in one felt252 </h3>
  <img src="https://raw.githubusercontent.com/baitcode/cairo-fixed-point-arithmetic/refs/heads/main/assets/fixed_point_arithmetics.webp" height="200">
  <br />

  <div style="text-align: center;">  
  <a href="https://github.com/baitcode/cairo-fixed-point-arithmetic/issues/new?assignees=&labels=bug&template=bug_report.md&title=bug%3A+">Report a Bug</a>
  -
  <a href="https://github.com/baitcode/cairo-fixed-point-arithmetic/issues/new?assignees=&labels=enhancement&template=new_feature.md&title=feat%3A+">Request a Feature</a>
  -
  <a href="https://github.com/baitcode/cairo-fixed-point-arithmetic/discussions">Ask a Question</a>
  </div>
  <br />

</div>

## About

This crate was born in an effort to create fixed point datatype for [Ekubo Protocol](https://ekubo.org/) governance. It's specifically taiored to be used in smart-contracts. This library features:

- Fixed Point datatype that supports operations: multiplication, division, addition and substraction.
- Data packing and unpacking for smart contract storage.
- Overflow and underflow checking for all operations.
- Additional convenince methods for better performance without conversions such as `u64 by u128 division` method.
- Conversion from `u64`, `u128` and `u256` types.
- Rounding implementation.

Main type this crate export is:

```cairo
#[derive(Debug, Drop, Copy, Serde)]
pub struct UFixedPoint123x128 { 
    value: u256
}
```

Despite the fact this library don't derive `starknet::Store` it provides `fp::UFixedPoint123x128StorePacking` implementation for use in contract storage.

## Usage

All use-cases are perfectly described by this snippet.

```cairo
// Basic type import
use fp::{ UFixedPoint123x128 };

// Store packing implementation import
use fp::{ UFixedPoint123x128StorePacking };

// Convenience functions to avoid type conversions
use fp::{
    div_u64_by_u128, 
    div_u64_by_fixed_point, 
    mul_fixed_point_by_u128
}

fn main() {
    // Create a fixed point value 1.0
    let one: UFixedPoint123x128 = 1_u64.into();
    // Create a fixed point value 100.0
    let hundred: UFixedPoint123x128 = 100_u64.into();
    // Calculate a fixed point value 0.01
    let one_over_hundred = one / hundred;
    // OR
    let other_example = div_u64_by_u128(1, 100);

    assert_eq!(one_over_hundred, other_example );
    
    let multiplication_is_supported = one_over_hundred * hundred;
    assert_eq!(multiplication_is_supported, 1_u64.into());
    
    let two: UFixedPoint123x128 = 2_u64.into();
    let three: UFixedPoint123x128 = 3_u64.into();
    let six: UFixedPoint123x128 = 6_u64.into();
    let one_over_three = one / three;
    let one_over_six = one / six;

    // PartialEq is implemented, values are equal if they are close enough.
    // Difference is less than 1 / 2^124
    assert_eq!(one_over_three, one_over_six * two);
}
```

This crate also provides additional method for `UFixedPoint123x128` type through public 
`UFixedPoint123x128Impl` which implements `UFixedPointTrait`. 

```cairo
// Additional methods implementation
use fp::{ UFixedPoint123x128Impl };

UFixedPoint123x128Impl implements UFixedPointTrait 

trait UFixedPointTrait {
    // Returns integer part of the fixed point value
    fn get_integer(self: UFixedPoint123x128) -> u128;

    // Returns fractional part of the fixed point value
    fn get_fractional(self: UFixedPoint123x128) -> u128;
    
    // Rounds fixed point and returns integer part. 0.5 is rounded up.
    fn round(self: UFixedPoint123x128) -> u128;
}
```

## Contributing

[WIP] but feel free to open issue, discuss it with me and submit PR upon assignment.

## Special Thanks

<markdown-accessiblity-table data-catalyst=""><table>
<tbody>
<tr>
<td align="center" valign="top" width="14.28%">
<a href="https://github.com/shramee">
<img src="https://avatars.githubusercontent.com/u/11048263?v=4?v=4?s=100" width="100px;" alt="Shramee Srivastav" style="max-width: 100%;">
<br>
<sub><b>Shramee Srivastav</b></sub>
</a>
<br>
</td>      
<td align="center" valign="top">
For submitting bug report on unchecked error during packing due to incorrect MAX_INT value.
</td>
</tr>
</tbody>
</table>
</markdown-accessiblity-table>

## PS

Love and peace, dude. Hope it was useful.
