classdef Matrix < handle
    %% MATRIX class
    % TSA Matrix Profile class containing matrix profile methods.
    
    % -------------------------------------------------------------------
    % Copyright (c) 2018 Grumpy Cat Software S.L.
    %
    % This Source Code Form is subject to the terms of the Mozilla Public
    % License, v. 2.0. If a copy of the MPL was not distributed with this
    % file, You can obtain one at http://mozilla.org/MPL/2.0/.
    % -------------------------------------------------------------------
    
    methods(Static)
        function [discordsDistances, discordsIndices, subsequenceIndices] = ...
                findBestNDiscords(profile, index, n)
            %% FINDBESTNDISCORDS
            % This function extracts the best N discords from a previously
            % calculated matrix profile.
            %
            % *profile* A TSA Array instance pointing to the matrix profile
            % containing the minimum distance of each subsequence.
            %
            % *index* A TSA Array pointing to the matrix profile index
            % containing where each minimum occurs.
            %
            % *n* Number of discords to extract.
            %
            % *discordsDistances* A TSA Array pointing to the distance of
            % the best N discords.
            % 
            % *discordsIndices* A TSA Array pointing to the indices of the
            % best N discords.
            %
            % *subsequenceIndices* A TSA Array pointing to the indices of
            % the query sequences that produced the discords reported in
            % the discordsDistances output array.
            discordsDistancesRef = libpointer('voidPtrPtr');
            discordsIndicesRef = libpointer('voidPtrPtr');
            subsequenceIndicesRef = libpointer('voidPtrPtr');
            [~, ~, ~, discordsDistancesRef, discordsIndicesRef, ...
                subsequenceIndicesRef] = calllib('libtsac', ...
                'find_best_n_discords', profile.getReference(), ...
                index.getReference(), n, discordsDistancesRef, ...
                discordsIndicesRef, subsequenceIndicesRef);
            discordsDistances = tsa.Array(discordsDistancesRef);
            discordsIndices = tsa.Array(discordsIndicesRef);
            subsequenceIndices = tsa.Array(subsequenceIndicesRef);
        end
        
        function [motifsDistances, motifsIndices, subsequenceIndices] = ...
                findBestNMotifs(profile, index, n)
            %% FINDBESTNMOTIFS
            % This function extracts the best N motifs from a previously
            % calculated matrix profile.
            %
            % *profile* A TSA Array instance pointing to the matrix profile
            % containing the minimum distance of each subsequence.
            %
            % *index* A TSA Array pointing to the matrix profile index
            % containing where each minimum occurs.
            %
            % *n* Number of motifs to extract.
            %
            % *motifsDistances* A TSA Array pointing to the distance of
            % the best N motifs.
            % 
            % *motifsIndices* A TSA Array pointing to the indices of the
            % best N motifs.
            %
            % *subsequenceIndices* A TSA Array pointing to the indices of
            % the query sequences that produced the motifs reported in
            % the motifsDistances output array.
            motifsDistancesRef = libpointer('voidPtrPtr');
            motifsIndicesRef = libpointer('voidPtrPtr');
            subsequenceIndicesRef = libpointer('voidPtrPtr');
            [~, ~, ~, motifsDistancesRef, motifsIndicesRef, ...
                subsequenceIndicesRef] = calllib('libtsac', ...
                'find_best_n_motifs', profile.getReference(), ...
                index.getReference(), n, motifsDistancesRef, ...
                motifsIndicesRef, subsequenceIndicesRef);
            motifsDistances = tsa.Array(motifsDistancesRef);
            motifsIndices = tsa.Array(motifsIndicesRef);
            subsequenceIndices = tsa.Array(subsequenceIndicesRef);
        end
        
        function [profile, index] = stomp(tssa, tssb, m)
            %% STOMP
            % STOMP algorithm to calculate the matrix profile between *tssa*
            % and *tssb* using a subsequence length of *m*.
            %
            % *tssa* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *tssb* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *m* Number of discords to extract.
            %
            % *profile* A TSA Array instance pointing to the matrix profile
            % containing the minimum distance of each subsequence.
            %
            % *index* A TSA Array pointing to the matrix profile index
            % containing where each minimum occurs.
            profileRef = libpointer('voidPtrPtr');
            indexRef = libpointer('voidPtrPtr');
            [~, ~, ~, profileRef, indexRef] = calllib('libtsac', ...
                'stomp', tssa.getReference(), ...
                tssb.getReference(), m, profileRef, indexRef);
            profile = tsa.Array(profileRef);
            index = tsa.Array(indexRef);
        end
        
        function [profile, index] = stompSelfJoin(tss, m)
            %% STOMP
            % STOMP algorithm to calculate the matrix profile between *tss*
            % and itself using a subsequence length of 'm'. This method
            % filters the trivial matches.
            %
            % *tss* is an instance of the TSA array class, which points
            % to an array stored in the device side. Such array might
            % contain one or multiple time series (one per column).
            %
            % *m* Number of discords to extract.
            %
            % *profile* A TSA Array instance pointing to the matrix profile
            % containing the minimum distance of each subsequence.
            %
            % *index* A TSA Array pointing to the matrix profile index
            % containing where each minimum occurs.
            profileRef = libpointer('voidPtrPtr');
            indexRef = libpointer('voidPtrPtr');
            [~, ~, profileRef, indexRef] = calllib('libtsac', ...
                'stomp_self_join', tss.getReference(), m, profileRef, ...
                indexRef);
            profile = tsa.Array(profileRef);
            index = tsa.Array(indexRef);
        end
    end
end