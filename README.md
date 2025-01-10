<div align="center">
  <h1 align="center">Cairo Fixed Point Arithmetic</h1>
  <h3 align="center">Uses 124 bit for integer part and 128 for fractional and packs everything in one felt252 </h3>
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

## Usage

To use the lib

```


```