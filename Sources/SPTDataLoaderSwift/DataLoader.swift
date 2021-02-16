/*
 Copyright (c) 2015-2021 Spotify AB.

 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

import Foundation

/// A protocol that provides data request handling.
public protocol DataLoader {
    /// Creates a `Request` that can be used to retrieve the contents of a URL.
    /// - Parameter url: The `URL` for the request.
    /// - Parameter sourceIdentifier: The identifier for the request source. May be `nil`.
    /// - Returns: A new `Request` instance.
    func request(_ url: URL, sourceIdentifier: String?) -> Request
}

public extension SPTDataLoaderFactory {
    /// Convenience method for creating a Swift `DataLoader`.
    /// - Parameter responseQueue: The `DispatchQueue` on which to perform response handling.
    /// - Returns: A new `DataLoader` instance.
    func makeDataLoader(responseQueue: DispatchQueue = .global()) -> DataLoader {
        let sptDataLoader = createDataLoader()
        let dataLoaderWrapper = DataLoaderWrapper(dataLoader: sptDataLoader)

        sptDataLoader.delegate = dataLoaderWrapper
        sptDataLoader.delegateQueue = responseQueue

        return dataLoaderWrapper
    }
}
