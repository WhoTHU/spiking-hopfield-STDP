function get_mnist(dataDir)
% --------------------------------------------------------------------
% Preapre the imdb structure, returns image data with mean image subtracted
    files = {'train-images-idx3-ubyte', ...
            'train-labels-idx1-ubyte', ...
            't10k-images-idx3-ubyte', ...
            't10k-labels-idx1-ubyte'} ;

    if ~exist(dataDir, 'dir')
        mkdir(dataDir) ;
    end

    for i=1:4
        if ~exist(fullfile(dataDir, files{i}), 'file')
            url = sprintf('http://yann.lecun.com/exdb/mnist/%s.gz',files{i}) ;
            fprintf('downloading %s\n', url) ;
            gunzip(url, dataDir) ;
        end
    end

    f=fopen(fullfile(dataDir, 'train-images-idx3-ubyte'),'r') ;
    x1=fread(f,inf,'uint8');
    fclose(f) ;
    x1=permute(reshape(x1(17:end),28,28,60e3),[2 1 3]) ;

    f=fopen(fullfile(dataDir, 't10k-images-idx3-ubyte'),'r') ;
    x2=fread(f,inf,'uint8');
    fclose(f) ;
    x2=permute(reshape(x2(17:end),28,28,10e3),[2 1 3]) ;

    f=fopen(fullfile(dataDir, 'train-labels-idx1-ubyte'),'r') ;
    y1=fread(f,inf,'uint8');
    fclose(f) ;
    y1=double(y1(9:end)')+1 ;

    f=fopen(fullfile(dataDir, 't10k-labels-idx1-ubyte'),'r') ;
    y2=fread(f,inf,'uint8');
    fclose(f) ;
    y2=double(y2(9:end)')+1 ;

    mnist.train_data = single(reshape(x1, 28, 28, 1, []));
    mnist.test_data = single(reshape(x2, 28, 28, 1, []));
    mnist.data_mean = mean(mnist.train_data, 4);
    mnist.train_label = y1;
    mnist.test_label = y2;
    
    save('./data/mnist.mat', 'mnist');
end
