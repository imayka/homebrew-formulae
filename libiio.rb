class Libiio < Formula
  desc "Library for interfacing with local and remote Linux IIO devices"
  homepage "https://analogdevicesinc.github.io/libiio/"
  url "https://github.com/analogdevicesinc/libiio/archive/v0.23.tar.gz"
  sha256 "df1577740ea93dca732e7d7c04786600cb083117901dee793f3d38980754af00"
  license "LGPL-2.1"
  head "https://github.com/analogdevicesinc/libiio.git"

  depends_on "cmake" => :build

  depends_on "libserialport"
  depends_on "libusb"

  uses_from_macos "libxml2"

  def install
    mkdir "build" do
      cmake_args = [
        "-DOSX_INSTALL_FRAMEWORKSDIR=#{frameworks}",
        "-DOSX_PACKAGE=OFF",
      ]
      system "cmake", "..", *cmake_args, *std_cmake_args
      system "make"
      system "make", "install"
    end

    Dir.glob("#{frameworks}/iio.framework/Tools/*").each do |exec|
      bin.install_symlink exec if File.executable?(exec)
    end
  end

  test do
    system "#{bin}/iio_info", "--help"
  end
end
