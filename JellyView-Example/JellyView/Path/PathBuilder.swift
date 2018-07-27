//
// Created by Vladimir Kozlovskyi on 7/26/18.
// Copyright (c) 2018 Vladimir Kozlovskyi. All rights reserved.
//

import Foundation

protocol PathBuilder {
  func buildCurrentPath(inputData: PathInputData) -> Path
  func buildInitialPath(inputData: PathInputData) -> Path
  func buildExpandedPath(inputData: PathInputData) -> Path
}

func createPathBuilder(with position: Position) -> PathBuilder {
  switch position {
  case .left:
    return LeftSidePathBuilder()
  case .right:
    return RightSidePathBuilder()
  case .top:
    return TopSidePathBuilder()
  case .bottom:
    return BottomSidePathBuilder()
  }
}
