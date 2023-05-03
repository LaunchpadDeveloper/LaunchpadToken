// SPDX-License-Identifier: MIT

pragma solidity 0.8.9;

import '@openzeppelin/contracts/utils/Context.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol';

contract LaunchPadToken is Context, IERC20Metadata {
  mapping(address => uint256) private _balances;

  mapping(address => mapping(address => uint256)) private _allowances;

  uint256 private _totalSupply;

  string private _name;
  string private _symbol;
  uint8 private constant _decimals = 18;

  constructor(string memory name_, string memory symbol_) {
    _name = name_;
    _symbol = symbol_;
    _mint(0xF592CbE859fe4B135cA7a7990c793dcbC38eb99c, 400_000_000 * (10 ** _decimals)); //400 Million
    _mint(0x6A01A4BEEd4bA44D674235C15e8a1D0d2b9781c0, 250_000_000 * (10 ** _decimals)); //250 Million
    _mint(0x5CffF2Bf1A9C38b9847EE5beb8EFC537E58E5a65, 150_000_000 * (10 ** _decimals)); //150 Million
    _mint(0x43FA4065Bd5Ef7a24225a99b46164E0A151BE0e9, 100_000_000 * (10 ** _decimals)); //100 Million
    _mint(0x9b3fA57E1c07f9efBd1f15cF434B95AE2681bfFe, 100_000_000 * (10 ** _decimals)); //100 Million
  }

  function name() external view virtual override returns (string memory) {
    return _name;
  }

  function symbol() external view virtual override returns (string memory) {
    return _symbol;
  }

  function decimals() external view virtual override returns (uint8) {
    return _decimals;
  }

  function totalSupply() external view virtual override returns (uint256) {
    return _totalSupply;
  }

  function balanceOf(address account) external view virtual override returns (uint256) {
    return _balances[account];
  }

  function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
    _transfer(_msgSender(), recipient, amount);
    return true;
  }

  function allowance(address from, address to) external view virtual override returns (uint256) {
    return _allowances[from][to];
  }

  function approve(address to, uint256 amount) external virtual override returns (bool) {
    _approve(_msgSender(), to, amount);
    return true;
  }

  function transferFrom(address sender, address recipient, uint256 amount) external virtual override returns (bool) {
    _transfer(sender, recipient, amount);

    uint256 currentAllowance = _allowances[sender][_msgSender()];
    require(currentAllowance >= amount, 'ERC20: transfer amount exceeds allowance');
    unchecked {
      _approve(sender, _msgSender(), currentAllowance - amount);
    }

    return true;
  }

  function increaseAllowance(address to, uint256 addedValue) external virtual returns (bool) {
    _approve(_msgSender(), to, _allowances[_msgSender()][to] + addedValue);
    return true;
  }

  function decreaseAllowance(address to, uint256 subtractedValue) external virtual returns (bool) {
    uint256 currentAllowance = _allowances[_msgSender()][to];
    require(currentAllowance >= subtractedValue, 'ERC20: decreased allowance below zero');
    unchecked {
      _approve(_msgSender(), to, currentAllowance - subtractedValue);
    }

    return true;
  }

  function _transfer(address sender, address recipient, uint256 amount) internal virtual {
    require(amount > 0, 'ERC20: transfer amount is zero');
    require(sender != address(0), 'ERC20: transfer from the zero address');
    require(recipient != address(0), 'ERC20: transfer to the zero address');

    uint256 senderBalance = _balances[sender];
    require(senderBalance >= amount, 'ERC20: transfer amount exceeds balance');
    unchecked {
      _balances[sender] = senderBalance - amount;
    }
    _balances[recipient] += amount;

    emit Transfer(sender, recipient, amount);
  }

  function _mint(address account, uint256 amount) internal virtual {
    require(account != address(0), 'ERC20: mint to the zero address');

    _totalSupply += amount;
    _balances[account] += amount;
    emit Transfer(address(0), account, amount);
  }

  function _burn(address account, uint256 amount) internal virtual {
    require(account != address(0), 'ERC20: burn from the zero address');

    uint256 accountBalance = _balances[account];
    require(accountBalance >= amount, 'ERC20: burn amount exceeds balance');
    unchecked {
      _balances[account] = accountBalance - amount;
    }
    _totalSupply -= amount;

    emit Transfer(account, address(0), amount);
  }

  function burn(uint256 amount) external {
    _burn(_msgSender(), amount);
  }

  function _approve(address from, address to, uint256 amount) internal virtual {
    require(from != address(0), 'ERC20: approve from the zero address');
    require(to != address(0), 'ERC20: approve to the zero address');

    _allowances[from][to] = amount;
    emit Approval(from, to, amount);
  }
}
