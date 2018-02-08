class Libasr < Formula
  desc "A free, simple and portable asynchronous resolver library."
  homepage "https://github.com/OpenSMTPD/libasr"
  url "https://www.opensmtpd.org/archives/libasr-201602131606.tar.gz"
  sha256 "e5684a08d5eb61d68a94a24688f23bee8785c8a51a1bd34c88cae5aee5aa6da2"
  #head "https://github.com/OpenSMTPD/libasr.git", :branch => "master", :shallow => true
  head "https://github.com/twinshadow/libasr.git", :branch => "master", :shallow => true
  version "1.0.2-201602131606"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
  test do
    (testpath/"test.c").write <<~EOS
      #include <sys/types.h>
      #include <sys/socket.h>
      #include <errno.h>
      #include <netdb.h>
      #include <stdio.h>
      #include <string.h>
      #include <asr.h>

      int main() {
          struct asr_query *query;
          struct asr_result result;
          const char *hostname = "localhost";

          query = gethostbyname_async(hostname, NULL);
          asr_run_sync(query, &result);
          if (errno != 0) {
                  printf("asr run error: %s\\n", strerror(errno));
                  return 1;
          }
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lasr", "-o", "test"
    system "./test"
  end
end
