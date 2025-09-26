//
//  RegisterViewController.swift
//  CodeIDTest
//
//  Created by Ilham Prabawa on 26/09/25.
//

import UIKit

public class RegisterViewController: NiblessViewController {
  
  private let useCase: RegisterUseCase
  
  public init(useCase: RegisterUseCase) {
    self.useCase = useCase
    
    super.init()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}
