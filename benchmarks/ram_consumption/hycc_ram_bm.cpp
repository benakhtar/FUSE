/*
 * MIT License
 *
 * Copyright (c) 2022 Nora Khayata
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
#include <filesystem>

#include "common/common.h"

int main(int argc, char* argv[]) {
    namespace be = fuse::benchmarks;
    auto index = std::stoi(argv[argc - 1]);
    auto hyccTuple = be::kHyccCircuits.at(index);
    std::filesystem::path p(std::get<0>(hyccTuple));
    const auto name = p.parent_path().filename().string();

    auto res = be::loadHyccFromCircFile(std::get<0>(hyccTuple));
    std::cout << res.size() << std::endl;  // prevent compiler optimizations
    return 0;
}
