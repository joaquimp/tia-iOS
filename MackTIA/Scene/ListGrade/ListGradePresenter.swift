//
//  ListGradePresenter.swift
//  MackTIA
//
//  Created by Joaquim Pessoa Filho on 14/04/16.
//  Copyright (c) 2016 Mackenzie. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol ListGradePresenterInput {
    func presentFetchedGrades(response: ListGradeResponse)
}

protocol ListGradePresenterOutput: class {
    func displayFetchedGrades(viewModel: ListGradeViewModel.Success)
    func displayFetchedGradesError(viewModel: ListGradeViewModel.Error)
}

class ListGradePresenter: ListGradePresenterInput {
    weak var output: ListGradePresenterOutput!
    
    // MARK: Presentation logic
    
    func presentFetchedGrades(response: ListGradeResponse) {
        
        if response.error != nil {
            let error:(title:String,message:String) = ErrorParser.parse(response.error!)
            let viewModel = ListGradeViewModel.Error(errorMessage: error.message, errorTitle: error.title)
            output.displayFetchedGradesError(viewModel)
        } else {
            let viewModel = ListGradeViewModel.Success(grades: response.grades)
            output.displayFetchedGrades(viewModel)
        }
        
    }
}
